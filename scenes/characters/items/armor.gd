extends Node2D

@export var icon: Texture2D
@export var sprite: Texture2D

@export_category("Armor Defense")
@export var defense: Defense = Defense.new()

@export_category("Armor Adds")
@export var adds: ItemAdds = ItemAdds.new()

func on_armor_changed():
	for armor_part in get_tree().get_nodes_in_group("armor_part"):
		armor_part.texture = sprite
	
