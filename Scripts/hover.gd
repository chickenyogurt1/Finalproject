extends Sprite2D

var original_scale = Vector2.ONE

func _ready():
	original_scale = scale
	set_process(true)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	if get_rect().has_point(to_local(mouse_pos)):
		scale = original_scale *1.1
		
	else:
		scale = original_scale
		
