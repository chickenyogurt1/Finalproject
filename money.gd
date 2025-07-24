extends Control

func _process(delta: float) -> void:
	$Label.text = "$" + str(Global.player_money)
