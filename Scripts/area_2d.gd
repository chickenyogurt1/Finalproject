extends Area2D

@onready var police: Node2D

func _ready():
	police = $".."

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		police.jose.do_damage(police)
