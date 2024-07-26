extends Node2D

@export var armor: Armor
@export var weapon: Weapon
@export var shield: Shield
@export var ring: Ring
@export var amulet: Amulet

var player: Player


func _ready():
	player = get_parent().get_parent().get_parent()
	Events.connect("armor_equiped", on_armor_equiped)
	update_armor_texture()
	update_weapon_texture()
	update_shield_texture()
	

func on_shield_changed(new_shield: Shield):
	player.unequip_item(shield)
	shield = new_shield
	player.equip_item(shield)
	update_shield_texture()
	
	
func update_shield_texture():
	%Shield.texture = shield.texture

func on_weapon_changed(new_weapon: Weapon):
	player.unequip_item(weapon)
	weapon = new_weapon
	player.equip_item(weapon)
	update_weapon_texture()

func update_weapon_texture():
	get_node("WeaponSprite").texture = weapon.texture

func on_armor_equiped(new_armor: Armor): # quando sinal for emitido
	if new_armor == null:
		new_armor = load("res://resources/items/armors/default_armor.tres")
	player.unequip_item(armor)
	armor = new_armor
#	print("DEFESA: "+str(armor.defense.physical_defense))
	player.equip_item(armor)
	update_armor_texture()
	
	
func update_armor_texture():
	for armor_part in get_tree().get_nodes_in_group("armor_part"):
		armor_part.texture = armor.texture
	
func set_armor_defense(defense: Defense) -> void:
	self.defense = defense
	
func set_armor_adds(adds: Array[Add]) -> void:
	self.adds = adds
