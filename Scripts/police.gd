extends Node2D

const SPEED := 150
const FIGHT_RADIUS := 100
const SEARCH_RADIUS := 250
const CHASE_RADIUS := 300
const SHOOT_COOLDOWN := 1
const BULLETS := 5
const MAX_HEALTH := 20.0
const REGEN_COOLDOWN := 7

var health: float = MAX_HEALTH
var type: int
@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var progress_bar: ProgressBar = $CharacterBody2D/ProgressBar
@onready var jose: Jose = $"../Jose"

var smuggler_found: bool = false
var last_shot: float = 0
var bullets_left = BULLETS
var regen_cooldown

func get_animation(name: String) -> String:
	return name + str(type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	regen_cooldown = 0
	var random := RandomNumberGenerator.new()
	type = random.randi_range(1, 3)
	animated_sprite.play(get_animation("idle"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	add_to_group("police")

func get_nearest_smuggler():
	var all_smugglers = get_tree().get_nodes_in_group("smugglers")
	if (all_smugglers.size() == 0):
		return null
	var nearest_smuggler: Node2D = all_smugglers[0]
	all_smugglers.remove_at(0)
	
	for smuggler in all_smugglers:
		var pos = smuggler.global_position
		if global_position.distance_to(pos) < global_position.distance_to(nearest_smuggler.global_position):
			nearest_smuggler = smuggler
	
	return nearest_smuggler

func update_health(value: float):
	health = value
	progress_bar.value = health / MAX_HEALTH * 100

func _physics_process(delta: float) -> void:
	if (animated_sprite.animation.contains("dead")):
		return
	
	regen_cooldown += delta
	if (regen_cooldown > REGEN_COOLDOWN):
		regen_cooldown = 0
		update_health(health + 5)
	
	var smuggler = get_nearest_smuggler()
	if (smuggler == null):
		return
	var smuggler_pos = smuggler.animated_sprite.global_position
	var pos = global_position
	
	if (smuggler is Jose and smuggler.arrested):
		if (pos.distance_to(smuggler_pos) > 100):
			global_position = global_position.move_toward(smuggler_pos, 5)
		return

	if smuggler_found == true:
		if animated_sprite.flip_h == true and smuggler_pos.x >= pos.x:
			animated_sprite.flip_h = false
		elif animated_sprite.flip_h == false and smuggler_pos.x < pos.x:
			animated_sprite.flip_h = true
		
		if (bullets_left == 0):
			if (!animated_sprite.animation.contains("recharge")):
				animated_sprite.play(get_animation("recharge"))
			return
		
		if (!animated_sprite.animation.contains("shoot")):
			last_shot += delta
		
		if (pos.distance_to(smuggler_pos) > FIGHT_RADIUS and not animated_sprite.animation.contains("shoot")):
			global_position = global_position.move_toward(smuggler_pos, SPEED * delta)
			if (!animated_sprite.animation.contains("walk")):
				animated_sprite.play(get_animation("walk"))
		elif (animated_sprite.animation.contains("walk")):
			animated_sprite.play(get_animation("idle"))
				
		if last_shot > SHOOT_COOLDOWN:
			last_shot = 0
			animated_sprite.play(get_animation("shoot"))
			#animated_sprite.play
		
		if (pos.distance_to(smuggler_pos) > CHASE_RADIUS):
			smuggler_found = false
	
	else:
		if (pos.distance_to(smuggler_pos) <= SEARCH_RADIUS):
			smuggler_found = true
			last_shot = SHOOT_COOLDOWN


func take_damage(amount: int):
	update_health(health - amount)
	if (health <= 0):
		die()

func die():
	print("Police died")
	animated_sprite.play(get_animation("dead"))

func _on_animation_finished():
	if animated_sprite.animation.contains("shoot"):
		bullets_left -= 1
		await get_nearest_smuggler().take_damage(3, true)
		animated_sprite.play(get_animation("idle"))
	elif animated_sprite.animation.contains("recharge"):
		animated_sprite.play(get_animation("idle"))
		bullets_left = BULLETS
	elif animated_sprite.animation.contains("dead"):
		queue_free()
