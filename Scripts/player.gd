class_name Jose
extends Node2D

@export var inv: Inv

const SPEED = 200.0
const ACCEL = 2.0
const INITIAL_HEALTH = 50.0
const COOLDOWN := 1
const REGEN_COOLDOWN := 5
const FENCE_CLIMBING_TIME := 5

var attack_range = 100
var strength = 5
var hit_cooldown
var regen_cooldown

var input: Vector2
var health: float
var arrested := false
@onready var border_collision: Area2D = $"../BorderCollision"
@onready var body: CharacterBody2D = $JoseCharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $JoseCharacterBody2D/AnimatedSprite2D
@onready var arrested_panel: Control = $JoseCharacterBody2D/Arrested
@onready var progress_bar: ProgressBar = $JoseCharacterBody2D/HP/ProgressBar
@onready var fence_ui: Control = $JoseCharacterBody2D/Fence_Climbing
@onready var fence_progress_bar: ProgressBar = $JoseCharacterBody2D/Fence_Climbing/ProgressBar

func do_damage(receiver):
	if (receiver.global_position.distance_to(body.global_position) > attack_range):
		return
	if (hit_cooldown < COOLDOWN):
		return
	
	hit_cooldown = 0
	animated_sprite.play("attack")
	receiver.take_damage(strength)

func get_arrested():
	arrested_panel.visible = true
	animated_sprite.play("idle")
	arrested = true
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://UI/BribeUI.tscn")

func die() -> void:
	animated_sprite.play("dead")

func take_damage(amount: int, arrest: bool) -> void:
	update_health(health - amount)
	if (health <= 0):
		await get_arrested() if arrest else die()

func _on_animation_finished():
	if animated_sprite.animation == "dead":
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	elif animated_sprite.animation == "attack":
		animated_sprite.play("idle")

func _ready() -> void:
	fence_progress_bar.max_value = FENCE_CLIMBING_TIME
	regen_cooldown = 0
	hit_cooldown = COOLDOWN
	health = INITIAL_HEALTH
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	add_to_group("smugglers")
	add_to_group("jose")
	
	print("Main character health: " + str(health))

func get_input():
	input.x= Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y= Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()
	
func update_health(value: float):
	health = value
	progress_bar.value = health / INITIAL_HEALTH * 100

func _process(delta: float) -> void:
	if (animated_sprite.animation == "dead"):
		return
	
	var near_border := false
	for collision_body in border_collision.get_overlapping_bodies():
		if collision_body == body:
			near_border = true
			if not fence_ui.visible:
				fence_ui.visible = true
				fence_progress_bar.value = 0
			if (Input.is_key_pressed(KEY_E)):
				fence_progress_bar.value += delta
				if (fence_progress_bar.value >= FENCE_CLIMBING_TIME):
					body.position.y += 100
	if not near_border and fence_ui.visible:
		fence_ui.visible = false
	
	regen_cooldown += delta
	if (regen_cooldown > REGEN_COOLDOWN):
		regen_cooldown = 0
		update_health(health + 5)
	
	hit_cooldown += delta
	
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


func collect(item):
	inv.insert(item)
