class_name Weapond
extends Sprite2D

@export var physical_damage_min: int
@export var physical_damage_max: int

@export_category("Weapon Damage")  
@export var damage: Damage

enum QualityType{ COMMON = 0, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType

@export_category("Weapon Adds")  
#@export var adds: ItemAdds
@export var adds: Array[DamageAdd]
var max_possible_adds: int

func _init():
	set_max_possible_adds(quality)
	
	
func set_max_possible_adds(max_value):
	max_possible_adds = max_value
