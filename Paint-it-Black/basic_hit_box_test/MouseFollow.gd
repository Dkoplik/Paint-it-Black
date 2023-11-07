extends Node2D

var hit_box: BasicHitBox

func _ready():
	hit_box = $BasicHitBox


func _process(delta):
	hit_box.position = get_viewport().get_mouse_position()
