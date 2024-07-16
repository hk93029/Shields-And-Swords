extends Control

var drag_position
var attribute_points: int = 0
var original_position: Vector2

var new_str: int = 0
var new_cons: int = 0
var new_dex: int = 0
var new_int: int = 0

var current_str: int = 0
var current_cons: int = 0
var current_dex: int = 0
var current_int: int = 0

var character_status: CharacterStatus = CharacterStatus.new()
var character_attributes: CharacterAttributes = CharacterAttributes.new()

signal panel_moved

func _ready():
	visible = false
	original_position = global_position
	Events.connect("level_upped", on_level_upped)
	Events.connect("post_current_status", update_status)
	Events.connect("post_current_attributes", update_attributes)


func _input(event):
	if event.is_action_pressed("open_attributes_panel"):
		_change_panel_visibility()


func _on_gui_input(event):
	if event is InputEventMouseButton:
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


func change_attribute_pressed(attribute, operation):
	
	var add_or_sub: int = 0
	if(operation == "ADD"):
		if attribute_points == 0:
			return
		add_or_sub = 1
		
	elif(operation == "SUB"):
		add_or_sub = -1
		
	match attribute:
		"STR":
			if new_str == 0 and add_or_sub == -1:
				return
			new_str  += add_or_sub
			attribute_points += add_or_sub*-1
			
		"CONS":
			if new_cons == 0 and add_or_sub == -1:
				return
			new_cons += add_or_sub
			attribute_points += add_or_sub*-1
			
		"DEX":
			if new_dex == 0 and add_or_sub == -1:
				return
			new_dex += add_or_sub
			attribute_points += add_or_sub*-1
			
		"INT":
			if new_int == 0 and add_or_sub == -1:
				return
			new_int += add_or_sub
			attribute_points += add_or_sub*-1
	
	%AttributePointsValue.text = str(attribute_points)
	
	if(new_str != 0):
		%STR_VALUE.label_settings.font_color = Color.BLUE
	else:
		%STR_VALUE.label_settings.font_color = Color.WHITE
	if(new_cons != 0):
		%CONS_VALUE.label_settings.font_color = Color.BLUE
	else:
		%CONS_VALUE.label_settings.font_color = Color.WHITE	
	if(new_dex != 0):
		%DEX_VALUE.label_settings.font_color = Color.BLUE
	else:
		%DEX_VALUE.label_settings.font_color = Color.WHITE	
	if(new_int != 0):
		%INT_VALUE.label_settings.font_color = Color.BLUE
	else:
		%INT_VALUE.label_settings.font_color = Color.WHITE
		
	%STR_VALUE.text = str(current_str+new_str)
	%CONS_VALUE.text = str(current_cons+new_cons)
	%DEX_VALUE.text = str(current_dex+new_dex)
	%INT_VALUE.text = str(current_int+new_int)
	
		
func confirm_changes_pressed():
	
	current_str = int(%STR_VALUE.text)
	new_str = 0
	character_attributes.STR = current_str
	%STR_VALUE.label_settings.font_color = Color.WHITE
	
	current_cons = int(%CONS_VALUE.text)
	new_cons = 0
	character_attributes.CONS = current_cons
	%CONS_VALUE.label_settings.font_color = Color.WHITE
	
	current_dex = int(%DEX_VALUE.text)
	new_dex = 0
	character_attributes.DEX = current_dex
	%DEX_VALUE.label_settings.font_color = Color.WHITE
	
	current_int = int(%INT_VALUE.text)
	new_int = 0
	character_attributes.INT = current_int
	%INT_VALUE.label_settings.font_color = Color.WHITE
	
	Events.emit_signal("attributes_changed", character_attributes)


func cancel_changes_pressed():
	attribute_points += new_str
	new_str = 0
	attribute_points += new_cons
	new_cons = 0
	attribute_points += new_dex
	new_dex = 0
	attribute_points += new_int
	new_int = 0
	
	%STR_VALUE.text = str(current_str)
	%CONS_VALUE.text = str(current_cons)
	%DEX_VALUE.text = str(current_dex)
	%INT_VALUE.text = str(current_int)
	
	%STR_VALUE.label_settings.font_color = Color.WHITE
	%CONS_VALUE.label_settings.font_color = Color.WHITE
	%DEX_VALUE.label_settings.font_color = Color.WHITE
	%INT_VALUE.label_settings.font_color = Color.WHITE
	
	%AttributePointsValue.text = str(attribute_points)
	
func on_level_upped(attribute_points):
	self.attribute_points += attribute_points
	print("LEVEL UPPED!!: "+ str(self.attribute_points))
	%AttributePointsValue.text = str(self.attribute_points)


func update_status(new_char_status):
	character_status = new_char_status
	

func update_attributes(new_char_attributes):
	character_attributes = new_char_attributes
	%STR_VALUE.text = str(character_attributes.STR)
	%CONS_VALUE.text = str(character_attributes.CONS)
	%DEX_VALUE.text = str(character_attributes.DEX)
	%INT_VALUE.text = str(character_attributes.INT)
	
	current_str = character_attributes.STR
	current_cons = character_attributes.CONS
	current_dex  = character_attributes.DEX
	current_int = character_attributes.INT
	
