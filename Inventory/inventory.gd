extends Resource

class_name Inv

signal update

@export var slots: Array[Inv_slot] 


func insert(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	update.emit()

func remove(item: InvItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		var slot = itemslots[0]
		slot.amount -= 1
		if slot.amount <= 0:
			slot.item = null
			slot.amount = 0
		update.emit()
