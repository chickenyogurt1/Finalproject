extends Control

signal start_game

func _ready():
	if not $Start.is_connected("pressed", Callable(self, "_on_start_pressed")):
		$Start.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	emit_signal("start_game")
