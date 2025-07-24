# Global.gd
extends Node

const INITIAL_HEALTH = 50.0
var progress_bar

var goods = {
	"medicine": {"weight": 2, "value": 150, "risk": 0.9},
	"food": {"weight": 1, "value": 50, "risk": 0.3},
	"fuel": {"weight": 3, "value": 100, "risk": 0.7},
	"electronics": {"weight": 2, "value": 200, "risk": 0.8}
}

var crew = {
	"lookout": {"cost": 75, "effect": "risk_reduction"}
}

var player_money: int = 900
var player_health: float
var selected_goods = []
var hired_crew = []

func _ready() -> void:
	player_health = INITIAL_HEALTH

func _add_pistol():
	print("addedpistol")

func _add_knife():
	print("addedknife")


func _open_hiring_UI():
	var hire_ui_scene = preload("res://UI/HiringUI.tscn")
	var hire_ui = hire_ui_scene.instantiate()
	var ui_layer = get_tree().root.get_node("/root/Main/CanvasLayer/UI")
	ui_layer.add_child(hire_ui)
