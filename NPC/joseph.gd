extends Node2D

@export var dialog_timeline: String = "res://Timelines/joseph.dtl"
var player_in_range = false
var player = null

func _ready():
	$Label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_in_range:
		var item_name = Global.offer_random_item()
		if item_name != "":
			Dialogic.VAR["offered_item_name"] = item_name
			Dialogic.start(dialog_timeline)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "JoseCharacterBody2D":
		player_in_range = true
		$Label.visible = true
		player = body.get_parent()



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "JoseCharacterBody2D":
		player_in_range = false
		$Label.visible = false
		player = null
