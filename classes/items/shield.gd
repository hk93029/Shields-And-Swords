class_name Shield
extends Item

@export var texture: Texture2D

@export var  base_physical_defense: int :
	set(value):
		base_physical_defense = value
		physical_defense = base_physical_defense


var physical_defense: int = base_physical_defense

enum QualityType{ COMMON = 1, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType

var max_possible_adds: int = 0
var level: int = 1

@export_category("Shield Adds")  
@export var adds: Array[Add] :
		set(values):
			values.resize(quality) # Limita o valor de adicionais possíveis em um item
			for i in values.size():
				if values[i] == null:
					var new_add: Add = Add.new()
#					new_add.type = 0
					values[i] = new_add
			adds = values

@export_category("Weapon Refining")
@export var refining: int :
	set(value):
		refining = clamp(value, 0, 12)
		physical_defense = base_physical_defense+refining*2 if refining < 12 else base_physical_defense*2
		

func _init():
	item_type = ItemType.SHIELD

