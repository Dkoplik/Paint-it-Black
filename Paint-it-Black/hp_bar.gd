extends CanvasLayer

@export var player: CharacterBody2D
@onready var empty_heart = $EmptyHealth
@onready var full_heart = $FullHealth

var hp_component
var currentHp: int 
var one_heart_size: float

func _ready():
	assert(player != null)
	hp_component = (player.get_node("BasicHurtBox")).get_node("HP")
	currentHp = hp_component.get_current_hp()
	one_heart_size = full_heart.size.x
	full_heart.size.x = currentHp * one_heart_size
	empty_heart.size.x = currentHp * one_heart_size
	hp_component.connect("hp_changed", _on_hp_changed)

func _on_hp_changed(previous_hp, new_hp):
	currentHp = new_hp
	full_heart.size.x = currentHp * 32

func _process(delta):
	pass
