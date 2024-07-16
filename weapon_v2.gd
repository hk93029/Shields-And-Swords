class_name WeaponV2
extends Node2D

@export var icon: Texture2D
@export var sprite: Texture2D

@export_category("Weapon Physical Damage")
@export var min_physical_damage: int
@export var max_physical_damage: int

@export_category("Weapon Damage Adds")
@export var adds: Array[DamageAdd]

func on_weapon_changed(): # quando sinal for emitido
	update_weapon()
	
func update_weapon():
	var weapon = get_tree().get_first_node_in_group("weapon")
	weapon.texture = sprite
	
	
func set_weapon_damage_adds(adds: Array[DamageAdd]) -> void:
	self.adds = adds
	

