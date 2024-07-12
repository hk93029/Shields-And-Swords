extends CanvasLayer

var is_dragging: bool = false
var can_drag: bool = false


#func _input(event):
#	if event is InputEventMouse:
#		if Input.is_action_pressed("left_click") and can_drag:
#			is_dragging = true
#			Mouse.change_state(self)
#			print(self)
		
#		if is_dragging and event.is_action_released("left_click"):
#			is_dragging = false
#			Mouse.reset()
#			print("DDDDDDDDDDDDDDDDDDDDd")

#func _process(delta):
#	if is_dragging:
#		%AttributesPanel.position = get_viewport().get_mouse_position()


#func _on_area_2d_mouse_exited():
#	print("FFFFFFFFFFf")
#	if Mouse.target_body == self:
#		Mouse.target_body = null
#		print(Mouse.target_body)


#func _on_texture_rect_mouse_entered():
#	pass


#func _on_area_2d_mouse_entered():
#	if !is_dragging:
#		can_drag = true
#		Mouse.target_body = self
#		print(Mouse.target_body)

