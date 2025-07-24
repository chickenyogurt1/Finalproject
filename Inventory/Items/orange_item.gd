extends Node2D

@export var item: InvItem
var player = null
var player_in_range = false

func _ready():
	$Label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact") and player_in_range:
		player.collect(item)
		queue_free()


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
