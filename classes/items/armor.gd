class_name Armor
extends Item

@export var texture: Texture2D

@export_category("Armor Defense")
@export var physical_defense: int

@export_category("Armor Adds")
@export var adds: Array[Add]

func _init():
	item_type = ItemType.ARMOR
