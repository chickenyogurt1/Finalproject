extends Node2D
var draggable := false
var dragging := false
var is_inside_dropable := false
var body_ref
var offset := Vector2.ZERO
var initialPos := Vector2.ZERO
var mouse_over

# Static variable to track which bill is currently being dragged
static var currently_dragged

func _process(_delta: float) -> void:
	if not dragging and draggable and Input.is_action_just_pressed("Click") and mouse_over:
		# Only allow drag if no other bill is dragging
		if currently_dragged == null:
			currently_dragged = self
			dragging = true
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			get_parent().move_child(self, get_parent().get_child_count() - 1)
	if dragging:
		if Input.is_action_pressed("Click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("Click"):
			dragging = false
			currently_dragged = null
			var tween = get_tree().create_tween()
			if is_inside_dropable and body_ref:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				rotation_degrees = randi_range(-30,30)
				mouse_over = false
			else:
				tween.tween_property(self, "global_position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
				mouse_over = false

func _on_area_2d_mouse_entered() -> void:
	mouse_over = true
	if not dragging:
		draggable = true
		scale = Vector2(1.035, 1.035)

func _on_area_2d_mouse_exited() -> void:
	mouse_over = false
	if not dragging:
		draggable = false
		scale = Vector2(1, 1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body_ref = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == body_ref:
		is_inside_dropable = false
		body_ref = null
