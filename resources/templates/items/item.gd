class_name Item
extends Sprite2D

enum ItemType{WEAPON, ARMOR, RING, AMULET, GEM, CRAFT_MATERIAL, REFINING_DUST}

@export var item_name: String
@export var icon: Texture2D
@export var price: int
var item_type: ItemType


