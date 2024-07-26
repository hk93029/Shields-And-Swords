class_name Armor
extends Item

@export var texture: Texture2D

@export_category("Armor Defense")
@export var defense: Defense = Defense.new()

@export_category("Armor Adds")
@export var adds: Array[Add]

