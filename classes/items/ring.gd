class_name Ring
extends Item

#@export var sprite: Texture2D
enum QualityType{ COMMON = 1, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType :
	set(value):
		quality = value

@export_category("Ring Adds")
@export var adds: Array[Add] :
	set(values):
		values.resize(quality)
		for i in values.size():
			if values[i] == null:
				var new_add: Add = Add.new()
#				new_add.type = 0
				values[i] = new_add
		adds = values
		
@export var refining: int = 0 :
	set(value):
		refining = clamp(value, 0, 12)


func _init():
	item_type = ItemType.RING
