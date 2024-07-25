class_name Armor
extends Item

@export var sprite: Texture2D

@export_category("Armor Defense")
@export var defense: Defense = Defense.new()

@export_category("Armor Adds")
@export var adds: Array[Add]


func on_armor_changed(): # quando sinal for emitido
	update_armor()
	
func update_armor():
	#for armor_part in get_tree().get_nodes_in_group("armor_part"):
	#	armor_part.texture = sprite
	pass
	
func set_armor_defense(defense: Defense) -> void:
	self.defense = defense
	
func set_armor_adds(adds: Array[Add]) -> void:
	self.adds = adds
