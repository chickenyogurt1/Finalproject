extends Node2D
var item_scenes = [
	preload("res://Inventory/Items/apple_item.tscn"),
	preload("res://Inventory/Items/banana_item.tscn"),
	preload("res://Inventory/Items/soup_item.tscn"),
	preload("res://Inventory/Items/orange_item.tscn"),
	preload("res://Inventory/Items/coke_item.tscn"),
	preload("res://Inventory/Items/cheese_item.tscn")
]
@export var items_per_pallet := 4
@export var pallet_size := Vector2(100, 100)
@export var items_per_row := 2

func _ready():
	randomize()
	var rows = int(ceil(float(items_per_pallet) / items_per_row))
	var spacing_x = pallet_size.x / items_per_row
	var spacing_y = pallet_size.y / rows
	var grid_width = items_per_row * spacing_x
	var grid_height = rows * spacing_y
	var offset = (pallet_size - Vector2(grid_width, grid_height)) / 2
	for i in range(items_per_pallet):
		var index = randi() % item_scenes.size()
		var item_instance = item_scenes[index].instantiate()
		item_instance.scale = Vector2(0.6, 0.6)  
		$Pallet.add_child(item_instance)
		var col = i % items_per_row
		var row = i / items_per_row

		var pos_x = col * spacing_x + spacing_x / 2
		var pos_y = row * spacing_y + spacing_y / 2
		item_instance.position = -offset + Vector2(pos_x, pos_y)
