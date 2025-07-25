extends Node
var main_menu_scene = preload("res://Scenes/MainMenu.tscn")
var game_world_scene = preload("res://Scenes/GameWorld.tscn")

var current_scene = null

func _ready():
	Global.progress_bar = $CanvasLayer/UI/HP/ProgressBar
	show_main_menu()
	$CanvasLayer/UI.visible = false
	if Global.trigger_start_game:
		Global.trigger_start_game = false
		_on_start_game()

func show_main_menu():
	if current_scene:
		current_scene.queue_free()
	current_scene = main_menu_scene.instantiate()
	add_child(current_scene)

	if current_scene.has_signal("start_game"):
		current_scene.connect("start_game", Callable(self, "_on_start_game"))

func _on_start_game():
	if current_scene:
		current_scene.queue_free()
	current_scene = game_world_scene.instantiate()
	add_child(current_scene)
	$CanvasLayer/UI.visible = true
