# Global.gd
extends Node

const INITIAL_HEALTH = 50.0
var progress_bar
signal get_knife

var player_inventory: Inv = null

var goods = {
	"apple": {"weight": 2, "value": 30, "risk": 0.9},
	"banana": {"weight": 1, "value": 50, "risk": 0.3},
	"cheese": {"weight": 3, "value": 40, "risk": 0.7},
	"coke": {"weight": 2, "value": 60, "risk": 0.8},
	"orange": {"weight": 2, "value": 25, "risk": 0.8},
	"soup": {"weight": 2, "value": 35, "risk": 0.8}
}

var player_money: int = 900
var player_health: float
var hired_crew = []

var last_delivered_item: String = ""
var offered_item: InvItem = null

func _ready() -> void:
	player_health = INITIAL_HEALTH

func offer_random_item() -> String:
	if player_inventory == null:
		return ""
	var filled_slots = player_inventory.slots.filter(func(slot): return slot.item != null and slot.amount > 0)
	if filled_slots.is_empty():
		offered_item = null
		return ""
	var slot = filled_slots[randi() % filled_slots.size()]
	offered_item = slot.item
	return offered_item.name

func confirm_trade() -> int:
	if offered_item == null or !goods.has(offered_item.name):
		print("whaaaaa")
		return 0
	var value = goods[offered_item.name]["value"]
	player_inventory.remove(offered_item)
	player_money += value
	offered_item = null
	return value

func _add_knife():
	player_money -= 100
	emit_signal("get_knife")
	
func _open_hiring_UI():
	var hire_ui_scene = preload("res://UI/HiringUI.tscn")
	var hire_ui = hire_ui_scene.instantiate()
	var ui_layer = get_tree().root.get_node("/root/Main/CanvasLayer/UI")
	ui_layer.add_child(hire_ui)


func _add_pistol():
	print("addedpistol")
