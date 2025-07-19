extends CharacterBody2D

const SPEED = 500.0
const ACCEL = 2.0

var input: Vector2

func get_input():
	input.x= Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y= Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()

func _process(delta: float) -> void:
	var playerInput = get_input()
	if playerInput != Vector2.ZERO:
		velocity = playerInput * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()
