class_name Jose
extends Node2D

const SPEED = 300.0
const ACCEL = 2.0
const INITIAL_HEALTH = 20

var input: Vector2
var health: float
@onready var body: CharacterBody2D = $CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D


func die() -> void:
	animated_sprite.play("dead")

func take_damage(amount: int) -> void:
	health -= amount
	print("Main character health: " + str(health))
	if (health <= 0):
		die()

func _on_animation_finished():
	if animated_sprite.animation == "dead":
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")

func _ready() -> void:
	health = INITIAL_HEALTH
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	
	print("Main character health: " + str(health))

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
