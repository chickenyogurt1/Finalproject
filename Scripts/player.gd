class_name Jose
extends Node2D

@export var inv: Inv

const SPEED = 200.0
const ACCEL = 2.0
const COOLDOWN := 1
const REGEN_COOLDOWN := 5
const FENCE_CLIMBING_TIME := 7
const FIST_STRENGTH := 4
const KNIFE_STRENGTH := 8
var ATTACK_RANGE = 100

var strength
var hit_cooldown
var regen_cooldown

var input: Vector2
var arrested := false
var has_knife := false
@onready var border_collision: Area2D = $"../BorderCollision"
@onready var body: CharacterBody2D = $JoseCharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $JoseCharacterBody2D/AnimatedSprite2D
@onready var arrested_panel: Control = $JoseCharacterBody2D/Arrested
@onready var fence_ui: Control = $JoseCharacterBody2D/Fence_Climbing
@onready var fence_progress_bar: ProgressBar = $JoseCharacterBody2D/Fence_Climbing/ProgressBar

func get_knife():
	has_knife = true
	strength = KNIFE_STRENGTH
	
func remove_knife():
	has_knife = false
	strength = FIST_STRENGTH

func get_animation(name):
	if has_knife:
		name += "_knife"
	return name

func do_damage(receiver):
	if (receiver.global_position.distance_to(body.global_position) > ATTACK_RANGE):
		return
	if (hit_cooldown < COOLDOWN):
		return
	
	hit_cooldown = 0
	animated_sprite.play(get_animation("attack"))
	receiver.take_damage(strength)

func get_arrested():
	arrested_panel.visible = true
	animated_sprite.play(get_animation("idle"))
	arrested = true
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://UI/BribeUI.tscn")

func die() -> void:
	animated_sprite.play(get_animation("dead"))

func take_damage(amount: int, arrest: bool) -> void:
	update_health(Global.player_health - amount)
	if (Global.player_health <= 0):
		await get_arrested() if arrest else die()

func update_health(value: float):
	if value > Global.INITIAL_HEALTH:
		value = Global.INITIAL_HEALTH
	Global.player_health = value
	Global.progress_bar.value = Global.player_health / Global.INITIAL_HEALTH * 100


func _on_animation_finished():
	if animated_sprite.animation.contains("dead"):
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	elif animated_sprite.animation.contains("attack"):
		animated_sprite.play(get_animation("idle"))

func _ready() -> void:
	strength = FIST_STRENGTH
	Global.player_inventory = self.inv
	fence_progress_bar.max_value = FENCE_CLIMBING_TIME
	regen_cooldown = 0
	hit_cooldown = COOLDOWN
	Global.connect("get_knife", Callable(self, "get_knife"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	add_to_group("smugglers")
	add_to_group("jose")

func get_input():
	input.x= Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input.y= Input.get_action_strength("Down") - Input.get_action_strength("Up")
	return input.normalized()


func _process(delta: float) -> void:
	if (animated_sprite.animation.contains("dead")):
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
					fence_progress_bar.value = 0
					if body.global_position.y > $"../BorderCollision/CollisionShape2D".global_position.y:
						body.position.y -= 100
					else:
						body.position.y += 100
	if not near_border and fence_ui.visible:
		fence_ui.visible = false
	regen_cooldown += delta
	if (regen_cooldown > REGEN_COOLDOWN):
		regen_cooldown = 0
		update_health(Global.player_health + 5)
	
	hit_cooldown += delta
	
	var playerInput = get_input()
	
	# Player texture changes
	if (animated_sprite.flip_h == true and playerInput.x > 0):
		animated_sprite.flip_h = false
	elif (animated_sprite.flip_h == false and playerInput.x < 0):
		animated_sprite.flip_h = true
	if (animated_sprite.animation.contains("walk") and playerInput == Vector2.ZERO):
		animated_sprite.play(get_animation("idle"))
	elif (animated_sprite.animation.contains("idle") and playerInput != Vector2.ZERO):
		animated_sprite.play(get_animation("walk"))
	
	# Movements
	body.velocity = playerInput * SPEED
	body.move_and_slide()


func collect(item):
	inv.insert(item)
