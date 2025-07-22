extends Control

@onready var bills_container = $BillsContainer
@onready var timer = randi_range(5, 10)
var bill_scene = preload("res://Assets/money/draggableMoney.tscn")




var bill_textures = {
	100: preload("res://Assets/money/100.png"),
	50: preload("res://Assets/money/50.png"),
	20: preload("res://Assets/money/20.png"),
	10: preload("res://Assets/money/10.png"),
	5: preload("res://Assets/money/5.png")
}

func _ready():
	$timer.text = str(timer)
	spawn_bills(Global.player_money)
	update_timer()

func update_timer():
	while timer > 0:
		await get_tree().create_timer(1.0).timeout
		timer -= 1
		$timer.text = str(timer)
	timerOver()

func break_money_into_bills(amount: int) -> Array:
	var bill_values = [100, 50, 20, 10, 5]
	var result := []

	for value in bill_values:
		while amount >= value:
			result.append(value)
			amount -= value

	if amount > 0:
		result.append(bill_values[-1])
	return result

func spawn_bills(amount: int) -> void:
	var bill_values = break_money_into_bills(amount)
	var top_left := Vector2(570, 150)
	var bottom_right := Vector2(1000, 415)
	for value in bill_values:
		var bill = bill_scene.instantiate()
		bill.bill_texture = bill_textures[value]
		bill.bill_value = value
		bill.add_to_group("bills")
		bills_container.add_child(bill)
		var rand_x := randf_range(top_left.x, bottom_right.x)
		var rand_y := randf_range(top_left.y, bottom_right.y)
		bill.global_position = Vector2(rand_x, rand_y)
		bill.spawnPos = bill.global_position
		bill.z_index = bill_values.find(value)


func get_total_in_hand(hand_area: Node) -> int:
	var total := 0
	for bill in get_tree().get_nodes_in_group("bills"):
		if bill.is_inside_dropable and bill.body_ref == hand_area:
			total += bill.bill_value
	return total

func timerOver():
	for bill in get_tree().get_nodes_in_group("bills"):
		bill.locked = true
		bill.draggable = false
		bill.dragging = false
	var moneyNeeded = Global.player_money * 0.2 + randi_range(-20, 60)
	if get_total_in_hand($handarea) >= moneyNeeded:
		$textbox.text = get_random_officer_response(true)
	else:
		$textbox.text = get_random_officer_response(false)


func get_random_officer_response(accepted: bool) -> String:
	var accept_lines = [
		"This never happened.",
		"I didn’t see a thing.",
		"Move along.",
		"You’re lucky I’m in a good mood.",
		"Pleasure doing business.",
		"You know the drill.",
		"Ah, democracy in action.",
		"That'll keep my memory fuzzy.",
		"For now, we’re friends."
	]
	var reject_lines = [
		"You think this buys your freedom?",
		"I don’t take handouts. Not from scum.",
		"Is that all you’ve got?",
		"Trying to buy me off? Cute.",
		"You think I’m cheap?",
		"You can’t pay your way out of this.",
		"The law isn’t for sale.",
		"I serve justice, not my wallet.",
		"What do I look like, a vending machine?",
		"Bribe me again and I’ll double your sentence."
	]
	if accepted:
		return accept_lines[randi() % accept_lines.size()]
	else:
		return reject_lines[randi() % reject_lines.size()]
