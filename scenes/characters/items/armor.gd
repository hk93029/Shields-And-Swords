class_name Armor
extends Node2D

@export var icon: Texture2D
@export var sprite: Texture2D

@export_category("Armor Defense")
@export var defense: Defense = Defense.new()

@export_category("Armor Adds")
@export var adds: ItemAdds = ItemAdds.new()


func on_armor_changed(): # quando sinal for emitido
	update_armor()
	
func update_armor():
	for armor_part in get_tree().get_nodes_in_group("armor_part"):
		armor_part.texture = sprite
	
func set_armor_defense(defense: Defense) -> void:
	self.defense = defense
	
func set_armor_adds(adds: ItemAdds) -> void:
	self.adds = adds
