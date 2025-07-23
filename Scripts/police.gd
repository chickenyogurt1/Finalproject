extends Node2D

const FIGHT_RADIUS := 300
const SEARCH_RADIUS := 600
const CHASE_RADIUS := 1000
const SHOOT_COOLDOWN := 1
const BULLETS := 5

var type: int
@onready var animated_sprite: AnimatedSprite2D = $CharacterBody2D/AnimatedSprite2D
@onready var main_character: Jose = $"../Jose"
var main_player_found: bool = false
var last_shot: float = 0
var bullets_left = BULLETS

func get_animation(name: String) -> String:
	return name + str(type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var random := RandomNumberGenerator.new()
	type = random.randi_range(1, 3)
	animated_sprite.play(get_animation("idle"))
	animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	var main_char_pos = main_character.animated_sprite.global_position
	var pos = global_position
	
	if (main_character.arrested):
		if (pos.distance_to(main_char_pos) > 100):
			global_position = global_position.move_toward(main_char_pos, 5)
		return
	#print(main_player_found)
	if main_player_found == true:
		if animated_sprite.flip_h == true and main_char_pos.x >= pos.x:
			animated_sprite.flip_h = false
		elif animated_sprite.flip_h == false and main_char_pos.x < pos.x:
			animated_sprite.flip_h = true
		
		if (bullets_left == 0):
			if (!animated_sprite.animation.contains("recharge")):
				animated_sprite.play(get_animation("recharge"))
			return
		
		if (!animated_sprite.animation.contains("shoot")):
			last_shot += delta
		
		if (pos.distance_to(main_char_pos) > FIGHT_RADIUS and not animated_sprite.animation.contains("shoot")):
			global_position = global_position.move_toward(main_char_pos, 5)
			animated_sprite.play(get_animation("walk"))
		elif (animated_sprite.animation.contains("walk")):
			animated_sprite.play(get_animation("idle"))
				
		if last_shot > SHOOT_COOLDOWN:
			last_shot = 0
			animated_sprite.play(get_animation("shoot"))
			#animated_sprite.play
		
		if (pos.distance_to(main_char_pos) > CHASE_RADIUS):
			main_player_found = false
	
	else:
		if (pos.distance_to(main_char_pos) <= SEARCH_RADIUS):
			main_player_found = true
			last_shot = SHOOT_COOLDOWN

func _on_animation_finished():
	if animated_sprite.animation.contains("shoot"):
		bullets_left -= 1
		await main_character.take_damage(1, true)
		animated_sprite.play(get_animation("idle"))
	elif animated_sprite.animation.contains("recharge"):
		animated_sprite.play(get_animation("idle"))
		bullets_left = BULLETS
