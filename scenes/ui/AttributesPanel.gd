extends Control

var drag_position

func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - %AttributesPanel.global_position
			Mouse.change_state(self)
		else:
			drag_position = null
	
	if event is InputEventMouseMotion and drag_position != null:
		%AttributesPanel.global_position = get_global_mouse_position() - drag_position





func _on_attributes_panel_gui_input(event, node):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - node.global_position
			Mouse.change_state(self)
		else:
			drag_position = null
	
	if event is InputEventMouseMotion and drag_position != null:
		node.global_position = get_global_mouse_position() - drag_position

