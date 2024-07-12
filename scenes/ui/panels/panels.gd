extends Control

func _ready():
	for panel in get_children():
		panel.connect("panel_moved", move_panel_to_front)
		panel.connect("mouse_entered", get_parent()._on_ui_mouse_entered)
		panel.connect("mouse_exited", get_parent()._on_ui_mouse_exited)
		
func move_panel_to_front(panel):
	move_child(panel, get_child_count() - 1)
