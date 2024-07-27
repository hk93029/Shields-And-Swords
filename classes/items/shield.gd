class_name Shield
extends Item

@export var texture: Texture2D

@export var  base_physical_defense: int :
	set(value):
		base_physical_defense = value
		physical_defense = value


var physical_defense: int = base_physical_defense

enum QualityType{ COMMON = 0, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType

var max_possible_adds: int = 0
var level: int = 1

@export_category("Shield Adds")  
@export var adds: Array[Add]

@export_category("Weapon Refining")
@export var refining = 0

func _init():
	item_type = ItemType.SHIELD

