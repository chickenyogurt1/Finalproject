extends Node2D

const SPEED = 300.0
const ACCEL = 2.0

var input: Vector2
@onready var body: CharacterBody2D = $CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D

func _ready() -> void:
	add_to_group("main_character")

func get_input():
	input.x= Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y= Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()

func _process(_delta: float) -> void:
	var playerInput = get_input()
	
	# Player texture changes
	if (animated_sprite.flip_h == true and playerInput.x >= 0):
		animated_sprite.flip_h = false
	elif (animated_sprite.flip_h == false and playerInput.x < 0):
		animated_sprite.flip_h = true
	if (animated_sprite.animation == "walk" and playerInput == Vector2.ZERO):
		animated_sprite.play("idle")
	elif (animated_sprite.animation == "idle" and playerInput != Vector2.ZERO):
		animated_sprite.play("walk")
	
	# Movements
	body.velocity = playerInput * SPEED
	body.move_and_slide()
