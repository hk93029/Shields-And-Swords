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

var str_add: int = 0
var cons_add: int = 0
var dex_add: int = 0
var int_add: int = 0

var str_default_color: Color = Color.WHITE
var cons_default_color: Color = Color.WHITE
var dex_default_color: Color = Color.WHITE
var int_default_color: Color = Color.WHITE


var character_status: CharacterStatus = CharacterStatus.new()
var character_attributes: CharacterAttributes = CharacterAttributes.new()

signal panel_moved

func _ready():
	visible = false
	original_position = global_position
	Events.connect("level_upped", on_level_upped)
	Events.connect("post_current_status", update_status)
	Events.connect("post_current_attributes", update_char_attributes)
	Events.connect("post_equips_attributes_adds", on_post_equips_attributes_adds)


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
	if visible == false:
		Mouse.is_dragging = false
		drag_position = null


func _on_close_button_pressed():
	visible = false
	Mouse.is_dragging = false
	drag_position = null


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
		str_default_color = Color.WHITE if str_add == 0 else Color.hex(0x28d9ffff)
		%STR_VALUE.label_settings.font_color = str_default_color
	if(new_cons != 0):
		%CONS_VALUE.label_settings.font_color = Color.BLUE
	else:
		cons_default_color = Color.WHITE if cons_add == 0 else Color.hex(0x28d9ffff)
		%CONS_VALUE.label_settings.font_color = cons_default_color	
	if(new_dex != 0):
		%DEX_VALUE.label_settings.font_color = Color.BLUE
	else:
		dex_default_color = Color.WHITE if dex_add == 0 else Color.hex(0x28d9ffff)
		%DEX_VALUE.label_settings.font_color = dex_default_color
	if(new_int != 0):
		%INT_VALUE.label_settings.font_color = Color.BLUE
	else:
		int_default_color = Color.WHITE if int_add == 0 else Color.hex(0x28d9ffff)
		%INT_VALUE.label_settings.font_color = int_default_color
		
	%STR_VALUE.text = str(current_str+new_str+str_add)
	%CONS_VALUE.text = str(current_cons+new_cons+cons_add)
	%DEX_VALUE.text = str(current_dex+new_dex+dex_add)
	%INT_VALUE.text = str(current_int+new_int+int_add)
	
		
func confirm_changes_pressed():
	
	current_str = int(%STR_VALUE.text)-str_add
	new_str = 0
	character_attributes.STR = current_str
	str_default_color = Color.hex(0x28d9ffff) if str_add != 0 else Color.WHITE
	%STR_VALUE.label_settings.font_color = str_default_color
	
	current_cons = int(%CONS_VALUE.text)-cons_add
	new_cons = 0
	character_attributes.CONS = current_cons
	cons_default_color = Color.hex(0x28d9ffff) if cons_add != 0 else Color.WHITE
	%CONS_VALUE.label_settings.font_color = cons_default_color
	
	current_dex = int(%DEX_VALUE.text)-dex_add
	new_dex = 0
	character_attributes.DEX = current_dex
	dex_default_color = Color.hex(0x28d9ffff) if dex_add != 0 else Color.WHITE
	%DEX_VALUE.label_settings.font_color = dex_default_color
	
	current_int = int(%INT_VALUE.text)-int_add
	new_int = 0
	character_attributes.INT = current_int
	int_default_color = Color.hex(0x28d9ffff) if int_add != 0 else Color.WHITE
	%INT_VALUE.label_settings.font_color = int_default_color
	
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
	
	%STR_VALUE.text = str(current_str+str_add)
	%CONS_VALUE.text = str(current_cons+cons_add)
	%DEX_VALUE.text = str(current_dex+dex_add)
	%INT_VALUE.text = str(current_int+int_add)
	
	str_default_color = Color.hex(0x28d9ffff) if cons_add != 0 else Color.WHITE
	%STR_VALUE.label_settings.font_color = str_default_color
	
	cons_default_color = Color.hex(0x28d9ffff) if cons_add != 0 else Color.WHITE
	%CONS_VALUE.label_settings.font_color = cons_default_color
	
	dex_default_color = Color.hex(0x28d9ffff) if cons_add != 0 else Color.WHITE
	%DEX_VALUE.label_settings.font_color = dex_default_color
	
	int_default_color = Color.hex(0x28d9ffff) if cons_add != 0 else Color.WHITE
	%INT_VALUE.label_settings.font_color = int_default_color
	
	%AttributePointsValue.text = str(attribute_points)
	
	
func on_level_upped(attribute_points):
	self.attribute_points += attribute_points
	#print("LEVEL UPPED!!: "+ str(self.attribute_points))
	%AttributePointsValue.text = str(self.attribute_points)


func update_status(new_char_status):
	character_status = new_char_status
	

func update_char_attributes(new_char_attributes):
	character_attributes = new_char_attributes
	%STR_VALUE.text = str(character_attributes.STR+str_add)
	%CONS_VALUE.text = str(character_attributes.CONS+cons_add)
	%DEX_VALUE.text = str(character_attributes.DEX+dex_add)
	%INT_VALUE.text = str(character_attributes.INT+int_add)
	
	current_str = character_attributes.STR
	current_cons = character_attributes.CONS
	current_dex  = character_attributes.DEX
	current_int = character_attributes.INT
	

func on_post_equips_attributes_adds(new_cons_add, new_str_add, new_dex_add, new_int_add):
	cons_add = new_cons_add
	str_add = new_str_add
	dex_add = new_dex_add
	int_add = new_int_add

	if cons_add != 0:
		cons_default_color = Color.hex(0x28d9ffff) if new_cons == 0 else Color.BLUE#RRGGBBAA
	else:
		cons_default_color = Color.WHITE if new_cons == 0 else Color.BLUE
		
	if str_add != 0:
		str_default_color = Color.hex(0x28d9ffff) if new_str == 0 else Color.BLUE#RRGGBBAA
	else:
		str_default_color = Color.WHITE if new_str == 0 else Color.BLUE
		
	if dex_add != 0:
		dex_default_color = Color.hex(0x28d9ffff) if new_dex == 0 else Color.BLUE#RRGGBBAA
	else:
		dex_default_color = Color.WHITE if new_dex == 0 else Color.BLUE
		
	if int_add != 0:
		int_default_color = Color.hex(0x28d9ffff)  if new_int == 0 else Color.BLUE#RRGGBBAA
	else:
		int_default_color = Color.WHITE if new_int == 0 else Color.BLUE
		
	%STR_VALUE.label_settings.font_color = str_default_color
	%CONS_VALUE.label_settings.font_color = cons_default_color
	%DEX_VALUE.label_settings.font_color = dex_default_color
	%INT_VALUE.label_settings.font_color = int_default_color
	
	%STR_VALUE.text = str(current_str+new_str+str_add)
	%CONS_VALUE.text = str(current_cons+new_cons+cons_add)
	%DEX_VALUE.text = str(current_dex+new_dex+dex_add)
	%INT_VALUE.text = str(current_int+new_int+int_add)
