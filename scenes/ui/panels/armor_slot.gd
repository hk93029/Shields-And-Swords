extends TextureRect


@onready var item_icon = $ItemIcon # Vai retornar a textura que estiver ativa
@onready var r = self.owner


func _ready():
	Events.connect("post_equipped_armor", on_post_equipped_armor)

func on_post_equipped_armor(armor):
	if armor != null:
		item_icon.item = armor
		item_icon.texture = armor.icon


func _can_drop_data(at_position, data): # Define se o dado pode ser dropado aqui, ou seja, o emissor também é receptor, ele pode transmitir para outros slots bem como receber.
	return data is TextureRect and data.item != null and data.item is Armor and r.get_requeriments(data.item)#or data.item is RefiningDust)
	
	
func _drop_data(at_position, data):
	Mouse.is_dragging = false
	var texture_temp = item_icon.texture
	var item_temp = item_icon.item
	item_icon.texture = data.texture # texture_rect.texture do destino recebe texture_rect.texture da origem, aqui ele é representado por "data", mas é exatamente texture_rect
	item_icon.item = data.item
	data.texture = texture_temp
	data.item = item_temp
	
	Events.emit_signal("armor_equipped", item_icon.item)
	$ItemIcon._on_mouse_entered()
