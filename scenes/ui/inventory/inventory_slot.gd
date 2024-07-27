extends TextureRect

var has_item: bool = false
#var item: Item

@onready var item_icon = $ItemIcon # Vai retornar a textura que estiver ativa
#var has_item: bool = false
#

func _can_drop_data(at_position, data): # Define se o dado pode ser dropado aqui, ou seja, o emissor também é receptor, ele pode transmitir para outros slots bem como receber.
	if data != null:
		if data.origin_slot != "Inventory":
			if data.item != null:
				if item_icon != null and item_icon.item != null and data.item.item_type != item_icon.item.item_type or !data.owner.get_requeriments(item_icon.item):
					#print(data.owner.get_requeriments(item_icon.item))
					return false
	return data is TextureRect
	

func _drop_data(at_position, data):
	Mouse.is_dragging = false
	var texture_temp = item_icon.texture
	var item_temp = item_icon.item
	item_icon.texture = data.texture # texture_rect.texture do destino recebe texture_rect.texture da origem, aqui ele é representado por "data", mas é exatamente texture_rect
	item_icon.item = data.item
	data.texture = texture_temp
	data.item = item_temp

	if data.origin_slot == "Armor":
		Events.emit_signal("armor_equipped", data.item)
	if data.origin_slot == "Weapon":
		Events.emit_signal("weapon_equipped", data.item)
	if data.origin_slot == "Shield":
		Events.emit_signal("shield_equipped", data.item)
