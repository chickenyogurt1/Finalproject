extends Node2D

const STRENGTH := 4
const SPEED := 150
const COOLDOWN := 1
const FIGHT_RADIUS := 50
const SEARCH_RADIUS := 600
const CHASE_RADIUS := 1000
const INITIAL_HEALTH := 30.0
const REGEN_COOLDOWN := 7

@onready var jose: Jose
@onready var progress_bar: ProgressBar = $CharacterBody2D/ProgressBar
@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
var police_found: bool = false
var last_hit
var health
var regen_cooldown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jose = get_tree().get_nodes_in_group("jose")[0]
	global_position = jose.body.global_position
	regen_cooldown = 0
	health = INITIAL_HEALTH
	animated_sprite.play("idle")
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))
	add_to_group("smugglers")

func get_nearest_police():
	var all_police = get_tree().get_nodes_in_group("police")
	if all_police.size() == 0:
		return null
	var nearest_police: Node2D = all_police[0]
	all_police.remove_at(0)
	
	for police in all_police:
		var pos = police.global_position
		if global_position.distance_to(pos) < global_position.distance_to(nearest_police.global_position):
			nearest_police = police
	
	return nearest_police

func update_health(value: float):
	if value > INITIAL_HEALTH:
		value = INITIAL_HEALTH
	health = value
	progress_bar.value = health / INITIAL_HEALTH * 100

func _physics_process(delta: float) -> void:
	if (animated_sprite.animation == "dead"):
		return
	
	regen_cooldown += delta
	if (regen_cooldown > REGEN_COOLDOWN):
		regen_cooldown = 0
		update_health(health + 5)

	var police = get_nearest_police()
	#if police == null:
		#if (global_position.distance_to(jose.body.global_position) > 100):
			#global_position = global_position.move_toward(jose.body.global_position, SPEED * delta)
		#return
	var pos = global_position
	var police_pos = jose.body.global_position if (not police_found) or police == null or pos.distance_to(jose.body.global_position) > 500 else police.global_position
	#print(main_player_found)
	if police_found == true:
		if animated_sprite.flip_h == true and police_pos.x >= pos.x:
			animated_sprite.flip_h = false
		elif animated_sprite.flip_h == false and police_pos.x < pos.x:
			animated_sprite.flip_h = true
		
		if (animated_sprite.animation != "attack"):
			last_hit += delta
		
		if (pos.distance_to(police_pos) > FIGHT_RADIUS):
			global_position = global_position.move_toward(police_pos, SPEED * delta)
			animated_sprite.play("walk")
		else:
			if (animated_sprite.animation == "walk"):
				animated_sprite.play("idle")
			if police != null and last_hit > COOLDOWN:
				last_hit = 0
				animated_sprite.play("attack")
		
		if (pos.distance_to(police_pos) > CHASE_RADIUS):
			police_found = false
	
	else:
		if (pos.distance_to(police_pos) <= SEARCH_RADIUS):
			police_found = true
			last_hit = COOLDOWN

func _on_animation_finished():
	if animated_sprite.animation == "attack":
		await get_nearest_police().take_damage(STRENGTH)
		animated_sprite.play("idle")
	elif animated_sprite.animation == "dead":
		queue_free()

func die() -> void:
	animated_sprite.play("dead")

func take_damage(amount: int, arrest: bool) -> void:
	update_health(health - amount)
	if (health <= 0):
		die()
