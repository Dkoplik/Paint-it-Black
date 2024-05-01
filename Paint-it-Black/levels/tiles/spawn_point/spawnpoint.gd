@tool
class_name SpawnPoint
extends CustomMarker2D

## Что спавнить?
@export var spawn_scene: PackedScene:
	set = set_spawn_scene
## Через сколько заспавнить после активации. Если активно с самого начала,
## то отчёт с начала загрузки сцены.
@export var spawn_delay: float = 0.0:
	set = set_spawn_delay
## Включена ли точка спавна. Если false, то ничего не происходит.
@export var enabled: bool = true:
	set = set_enabled
## Название спавна, отображается только в редакторе и нужно для удобства.
@export var spawnpoint_name: String:
	set = set_spawnpoint_name

## Сколько осталось до спавна.
var _before_spawn: float
## Отображает [member spawnpoint_name].
var _label_name: Label
## Есть ли [member spawn_scene].
var _has_spawn_scene: bool = false


func _ready() -> void:
	super()

	_label_name = %LabelName
	if Engine.is_editor_hint():
		return

	_label_name.hide()
	if enabled:
		start_count_down()


func check_configuration(warnings: PackedStringArray = []) -> bool:
	_has_spawn_scene = Utilities.check_reference(spawn_scene, "PackedScene", warnings)
	return _has_spawn_scene


func set_spawn_scene(value: PackedScene) -> void:
	spawn_scene = value
	update_configuration_warnings()


func set_spawn_delay(value: float) -> void:
	if (value < 0.0):
		return
	spawn_delay = value


func set_enabled(value: bool) -> void:
	enabled = value

	if not Engine.is_editor_hint() and enabled:
		start_count_down()


## Включает точку спавна.
func enable() -> void:
	enabled = true


## Отключает точку спавна.
func disable() -> void:
	enabled = false


## Переключает [member enabled] точки спавна.
func switch() -> void:
	enabled = not enabled


func set_spawnpoint_name(value: String) -> void:
	if not Engine.is_editor_hint():
		return
	
	_label_name = %LabelName
	spawnpoint_name = value

	if spawnpoint_name == "":
		_label_name.hide()
	else:
		_label_name.text = spawnpoint_name
		_label_name.show()


## Начинает отсчёт времени и спавнить сцену.
func start_count_down() -> void:
	await AutoloadUtilities.wait_for(spawn_delay)

	if not _has_spawn_scene:
		push_error("Отсутствует сцена для спавна")
		return

	var new_scene = spawn_scene.instantiate()
	new_scene.position = self.global_position
	get_tree().root.add_child(new_scene)
