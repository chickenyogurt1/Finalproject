extends Node2D

@export var dialog_timeline: String = "res://Timelines/weaponshop.dtl"
var player_in_range = false

func _ready():
	$Label.visible = false

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("Interact"):
		Dialogic.start(dialog_timeline)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "JoseCharacterBody2D":
		player_in_range = true
		$Label.visible = true



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "JoseCharacterBody2D":
		player_in_range = false
		$Label.visible = false
