extends Control

@onready var inv: Inv = preload("res://Inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var is_open = false

func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if is_open:
			close()
		else:
			open()


func open():
	visible = true
	is_open = true


func close():
	visible = false
	is_open = false
