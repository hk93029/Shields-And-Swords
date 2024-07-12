extends CanvasLayer

# Cursor styles
var arrow = load("res://assets/sprites/cursor/normal_cursor.png")
var pointing = load("res://assets/sprites/cursor/attack_cursor.png")
var pickup_hand = load("res://assets/sprites/cursor/pickup_hand.png")
var dialog_cursor = load("res://assets/sprites/cursor/dialog_cursor.png")

var target_body = null
var can_player_move: bool = true
var is_on_ui: bool = false
var is_dragging: bool = false

var group = {"enemy" : Input.CURSOR_POINTING_HAND, "draggable": Input.CURSOR_DRAG, "npc": Input.CURSOR_HELP}

func _ready():

	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(7, 7))
	Input.set_custom_mouse_cursor(pointing, Input.CURSOR_POINTING_HAND, Vector2(7, 7))
	Input.set_custom_mouse_cursor(pickup_hand, Input.CURSOR_DRAG, Vector2(7, 7))
	Input.set_custom_mouse_cursor(dialog_cursor, Input.CURSOR_HELP, Vector2(7, 7))
	

func change_state(body):
	target_body = body
	if body != null:
		if body.is_in_group("enemy"):
			Input.set_default_cursor_shape(group["enemy"])
			return
			
		if body.is_in_group("draggable"):
			print("IS DRAGGABLE!")
			Input.set_default_cursor_shape(group["draggable"])
			return
			
		if body.is_in_group("npc"):
			Input.set_default_cursor_shape(group["npc"])
			return
		
	reset()


func is_on_enemy():
	return Input.get_current_cursor_shape() == group["enemy"]
		
func is_on_npc():
	return Input.get_current_cursor_shape() == group["npc"]
		
func is_on_item():
	return Input.get_current_cursor_shape() == group["pickup_item"]

func is_draggable():
	return Input.get_current_cursor_shape() == group["draggable"]
	
func reset():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	target_body = null
