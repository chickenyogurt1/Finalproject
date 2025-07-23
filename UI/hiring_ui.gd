extends Control

@onready var lines_container = $Panel/LinesContainer
var line_scene = preload("res://UI/availablehires.tscn")

var hires = [
	{
		"name": "Ross",
		"desc": "Ross is an experienced boy who wanna join ur team [$850]",
		"image": "res://Assets/bosscartelwtv/suitedup/thig.png",
		"price": 850,
		"strength": 5
	},
	{
		"name": "Joseph",
		"desc": "Joseph is ready to protect you. [$650]",
		"image": "res://Assets/bosscartelwtv/buzzcut/Idle.png",
		"price": 650,
		"strength": 4
	},
	{
		"name": "Juan",
		"desc": "Juan has a gun. [$1230]",
		"image": "res://Assets/bosscartelwtv/weirdguy1/matey.png",
		"price": 1230,
		"strength": 7
	}
]

func _ready():
	for hire in hires:
		var line = line_scene.instantiate()
		lines_container.add_child(line)
		line.set_data(hire.image, hire.desc, hire)
		line.hire_pressed.connect(_on_hire_pressed.bind(line))  # ← pass line as second arg

# FIXED: added "line" as a second parameter
func _on_hire_pressed(data: Dictionary, line: Node):
	if data.price <= Global.player_money:
		print("You hired %s for $%d (STR: %d)" % [data.name, data.price, data.strength])
		line.queue_free()
	else:
		print("You can't afford %s. You have $%d" % [data.name, Global.player_money])



func _on_button_pressed() -> void:
	queue_free()
