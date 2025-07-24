extends Node

const SPAWN_COOLDOWN = 5

var police = preload("res://Scenes/Police.tscn")
var last_spawn = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var time = Time.get_unix_time_from_system()
	if (time - last_spawn > SPAWN_COOLDOWN):
		last_spawn = time
		var pos = Vector2(weighted_randf(-519, 1351, 841, 600), weighted_randf(128, 2741, 900, 300))
		var new_police = police.instantiate()
		get_tree().get_current_scene().add_child(new_police)
		new_police.global_position = pos
		print("Spawned new police at ", pos.x, ", ", pos.y)


func gaussian(x, mean, stddev):
	var variance = stddev * stddev
	return (1.0 / sqrt(2 * PI * variance)) * exp(-((x - mean) * (x - mean)) / (2 * variance))

func weighted_randf(min_val, max_val, peak, stddev):
	while true:
		var val = randf_range(min_val, max_val)
		var prob = gaussian(val, peak, stddev)
		if randf() < prob:
			return val
