class_name Armor
extends Item

@export var texture: Texture2D

@export_category("Armor Defense")
@export var base_physical_defense: int :
	set(value):
		base_physical_defense = value
		physical_defense = base_physical_defense

var physical_defense: int
		

@export_category("Armor Adds")
@export var adds: Array[Add]

@export_category("Armor Refining")
@export var refining: int :
	set(value):
		refining = value
		physical_defense = base_physical_defense+refining*2
		
enum QualityType{ COMMON = 0, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType

var max_possible_adds: int = 0

func _init():
	item_type = ItemType.ARMOR


func _ready():

	set_max_possible_adds(quality)
	init_armor_adds_slots()
	update_armor_physical_defense(base_physical_defense)
	print("refining: +["+str(refining)+"]")
	print("defense: "+str(physical_defense)+" ("+str(physical_defense)+")")
	

func set_max_possible_adds(max_value):
	max_possible_adds = max_value
	
	
func init_armor_adds_slots():
	for index in max_possible_adds:
		adds.append(Add.new())


func update_armor_physical_defense(base_physical_defense):
	physical_defense = base_physical_defense+refining*2
	
