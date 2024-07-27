extends Control

var drag_position
var attribute_points: int = 0
var original_position: Vector2
var mouse_is_on_edge:bool = false
var player_attributes_ref: CharacterAttributes
var player_level_ref: int

signal panel_moved

func _ready():
	Events.connect("post_current_level", on_post_current_level)
	Events.connect("post_current_attributes", on_post_current_attributes)
	
	visible = false
	original_position = global_position


func get_requeriments(item) -> bool:
	#print("LVL NECESSARIO: "+str(item.necessary_level))
	if item == null:
		return true
	
	return item.necessary_level <= player_level_ref \
		and item.necessary_str <= player_attributes_ref.STR \
		and item.necessary_dex <= player_attributes_ref.DEX \
		and item.necessary_int <=  player_attributes_ref.INT


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
	if visible == false:
		Mouse.is_dragging = false
		drag_position = null


func _on_close_button_pressed():
	visible = false
	Mouse.is_dragging = false


func _on_character_edge_mouse_entered():
	mouse_is_on_edge = true


func _on_character_edge_mouse_exited():
	mouse_is_on_edge = false
	

func on_post_current_level(level):
	player_level_ref = level
	

func on_post_current_attributes(attributes):
	player_attributes_ref = attributes
