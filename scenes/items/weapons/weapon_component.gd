class_name WeaponComponent2
extends Node

var Damage = preload("res://resources/types/damage.gd")

@export_category("WEAPON ADDITIONALS")  
@export var additional_type: Dictionary = { "str": 0, "cons": 0, "dex": 0, "int": 0}

@export_subgroup("Special Atributes")
@export var special_atributes: Dictionary = { "critical_chance": 0.0, "critical_damage": 0.0, "attack_speed": 0.0 }

@export_subgroup("Incremental Atributes")
@export var incremental_atributes: Dictionary = { "hp": 0, "mp": 0}

#@export var physical_damage_min: int
#@export var physical_damage_max: int
@export var damage: Damage
