extends Control

signal start_game

func _ready():
	if not $VBoxContainer/Start.is_connected("pressed", Callable(self, "_on_start_pressed")):
		$VBoxContainer/Start.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	emit_signal("start_game")
