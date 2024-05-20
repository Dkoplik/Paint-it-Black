class_name SpawnSceneAction
extends SpawnPointAction

## Какую сцену спавнить?
@export var spawning_scene: PackedScene
## Сдвиг точки спавна от маркера.
@export var offset := Vector2.ZERO

## Маркер, на котором спавнить сцену.
var spawning_marker: Marker2D

var _has_spawning_scene := false
var _has_spawning_marker := false


func _init() -> void:
	_class_name = &"SpawnSceneAction"


func do_action() -> bool:
	super()
	if not _has_spawning_scene:
		return false

	if not _has_spawning_marker:
		return false

	var scene_instance := spawning_scene.instantiate()
	scene_instance.position = spawning_marker.global_position + offset
	spawning_marker.get_tree().current_scene.add_child(scene_instance)

	action_completed.emit()
	return true


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_spawning_scene = Utilities.check_resource(spawning_scene, "PackedScene", warnings)
	_has_spawning_marker = Utilities.check_reference(spawning_marker, "Marker2D", warnings)
	return _has_spawning_marker && _has_spawning_scene
