extends TextureRect

var has_item: bool = false
var item: Item

@onready var item_icon = $ItemIcon # Vai retornar a textura que estiver ativa
#var has_item: bool = false
#

func _can_drop_data(at_position, data): # Define se o dado pode ser dropado aqui, ou seja, o emissor também é receptor, ele pode transmitir para outros slots bem como receber.
	return data is TextureRect
	

func _drop_data(at_position, data):
	var temp = item_icon.texture
	item_icon.texture = data.texture # texture_rect.texture do destino recebe texture_rect.texture da origem, aqui ele é representado por "data", mas é exatamente texture_rect
	data.texture = temp

