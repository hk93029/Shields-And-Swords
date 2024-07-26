extends Control

var drag_position
var attribute_points: int = 0
var original_position: Vector2
var mouse_is_on_edge:bool = false

signal panel_moved

func _ready():
	visible = false
	original_position = global_position

func _input(event):
	if event.is_action_pressed("open_character_panel"):
		_change_panel_visibility()


func _on_gui_input(event):
	if event is InputEventMouseButton and mouse_is_on_edge:
		if event.pressed:
			drag_position = get_global_mouse_position() - global_position
			emit_signal("panel_moved", self)
			Mouse.is_dragging = true
		else:
			drag_position = null
			Mouse.is_dragging = false
	
	if event is InputEventMouseMotion and drag_position != null:
		global_position = get_global_mouse_position() - drag_position
		

func _change_panel_visibility():
	visible = !visible
	global_position = original_position

func _on_close_button_pressed():
	visible = false


func _on_character_edge_mouse_entered():
	mouse_is_on_edge = true
	print("ENTROU!!")

func _on_character_edge_mouse_exited():
	mouse_is_on_edge = false
	print("SAIU!!")
