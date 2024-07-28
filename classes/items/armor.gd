class_name Armor
extends Item

@export var texture: Texture2D

@export_category("Armor Defense")
@export var base_physical_defense: int :
	set(value):
		base_physical_defense = value
		physical_defense = base_physical_defense

var physical_defense: int

enum QualityType{ COMMON = 1, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType

var max_possible_adds: int = 0

@export_category("Armor Adds")
@export var adds: Array[Add] :
		set(values):
			values.resize(quality) # Limita o valor de adicionais possíveis em um item
			for i in values.size():
				if values[i] == null:
					var new_add: Add = Add.new()
#					new_add.type = 0
					values[i] = new_add
			adds = values

@export_category("Armor Refining")
@export var refining: int :
	set(value):
		refining = clamp(value, 0, 12)
		physical_defense = base_physical_defense+refining*2 if refining < 12 else base_physical_defense*2
		

func _init():
	item_type = ItemType.ARMOR


func _ready():
	set_max_possible_adds(quality)
	init_armor_adds_slots()
	update_armor_physical_defense(base_physical_defense)
#	print("refining: +["+str(refining)+"]")
#	print("defense: "+str(physical_defense)+" ("+str(physical_defense)+")")
	

func set_max_possible_adds(max_value):
	max_possible_adds = max_value
	
	
func init_armor_adds_slots():
	for index in max_possible_adds:
		if adds[index] == null:
			adds[index] = Add.new()



func update_armor_physical_defense(base_physical_defense):
	physical_defense = base_physical_defense+refining*2
	
