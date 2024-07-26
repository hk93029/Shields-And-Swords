class_name Item
extends Resource

enum ItemType{WEAPON, ARMOR, RING, AMULET, GEM, CRAFT_MATERIAL, CONSUMABLE, REFINING_DUST}

@export var item_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var price: int
var quantity: int = 1
var item_type: ItemType
var is_stackable: bool = false
var is_consumable: bool = false

@export var necessary_level: int = 1
@export var necessary_str: int = 1
@export var necessary_dex: int = 1
@export var necessary_int: int = 1
#var necessary_class: ClassType
