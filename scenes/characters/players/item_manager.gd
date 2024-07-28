extends Node2D

@export var armor: Armor
@export var weapon: Weapon
@export var shield: Shield
@export var ring: Ring
@export var amulet: Amulet

var player: Player


func _ready():
	player = get_parent().get_parent().get_parent()
	Events.connect("armor_equipped", on_armor_equipped)
	Events.connect("weapon_equipped", on_weapon_equipped)
	Events.connect("shield_equipped", on_shield_equipped)
	Events.connect("ring_equipped", on_ring_equipped)
	
	post_equipped_items()

	if armor == null:
		armor = load("res://resources/items/armors/default_armor.tres")
	if weapon == null:
		weapon = load("res://resources/items/weapons/empty_weapon.tres")
	if shield == null:
		shield = load("res://resources/items/shields/empty_shield.tres")
	if ring == null:
		ring = load("res://resources/items/rings/empty_ring.tres")
	if amulet == null:
		pass
	
	update_armor_texture()
	update_weapon_texture()
	update_shield_texture()


func post_equipped_items():
	Events.emit_signal("post_equipped_armor", armor)
#	if weapon == null:
#		weapon = load("res://resources/items/weapons/empty_weapon.tres")
	Events.emit_signal("post_equipped_weapon", weapon)
	Events.emit_signal("post_equipped_shield", shield)
	Events.emit_signal("post_equipped_ring", ring)
	Events.emit_signal("post_equipped_amulet", amulet)


func on_ring_equipped(new_ring: Ring):
	if new_ring == null:
		new_ring = load("res://resources/items/rings/empty_ring.tres")
	player.unequip_item(ring)
	ring = new_ring
	player.equip_item(ring)


func on_shield_equipped(new_shield: Shield):
	if new_shield == null:
		new_shield = load("res://resources/items/shields/empty_shield.tres")
	player.unequip_item(shield)
	shield = new_shield
	player.equip_item(shield)
	update_shield_texture()
	
	
func update_shield_texture():
	%Shield.texture = shield.texture if shield != null else null
	if %Shield.texture == null:
		%Shield.color.a = 0
	else:
		%Shield.color.a = 1
		
		
func on_weapon_equipped(new_weapon: Weapon):
	if new_weapon == null:
		new_weapon = load("res://resources/items/weapons/empty_weapon.tres")
	player.unequip_item(weapon)
	weapon = new_weapon
	player.equip_item(weapon)
	update_weapon_texture()

func update_weapon_texture():
	get_node("WeaponSprite").texture = weapon.texture if weapon != null else null

func on_armor_equipped(new_armor: Armor): # quando sinal for emitido
	if new_armor == null:
		new_armor = load("res://resources/items/armors/default_armor.tres")
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
