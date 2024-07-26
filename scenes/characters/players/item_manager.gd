extends Node2D

@export var armor: Armor
@export var weapon: Weapon
@export var ring: Ring
@export var amulet: Amulet

@onready var player: Player = $Player


func on_weapon_changed(new_weapon: Weapon):
	player.unequip_item(weapon)
	weapon = new_weapon
	player.equip_item(weapon)
	update_weapon_texture()

func update_weapon_texture():
	get_node("WeaponSprite").texture = weapon.texture

func on_armor_changed(new_armor: Armor): # quando sinal for emitido
	player.unequip_item(armor)
	armor = new_armor
	player.equip_item(armor)
	update_armor_texture()
	
	
func update_armor_texture():
	for armor_part in get_tree().get_nodes_in_group("armor_part"):
		armor_part.texture = armor.texture
	
func set_armor_defense(defense: Defense) -> void:
	self.defense = defense
	
func set_armor_adds(adds: Array[Add]) -> void:
	self.adds = adds
