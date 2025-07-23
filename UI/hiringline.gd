extends Control

signal hire_pressed(data)

@onready var pic = $pic
@onready var label = $text
@onready var button = $hirebutton

var bodyguard_data = {}

func _ready():
	button.pressed.connect(_on_button_pressed)

func set_data(image_path: String, desc: String, data: Dictionary) -> void:
	pic.texture = load(image_path)
	label.text = desc
	bodyguard_data = data 

func _on_button_pressed():
	emit_signal("hire_pressed", bodyguard_data)
