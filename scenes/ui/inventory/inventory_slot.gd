extends TextureRect

var has_item: bool = false
#var item: Item

@onready var item_icon = $ItemIcon # Vai retornar a textura que estiver ativa
#var has_item: bool = false
#

func _can_drop_data(at_position, data): # Define se o dado pode ser dropado aqui, ou seja, o emissor também é receptor, ele pode transmitir para outros slots bem como receber.
	if data is TextureRect:
		if data.origin_slot == "Inventory": # Significa que o item veio do inventário, nessa condição que ele cai quando você troca de posição um item do inventário com outro item do inventário.
			return true
			
		else: # SE NÃO VEIO DO INVENTÁRIO, então veio de outro lugar, até o momento o único OUTRO LUGAR possível são os items equipados no personagem no PAINEL CHARACTER
			if data.item != null and item_icon.item == null: # Significa que o item que está VINDO DO PAINEL CHARACTER, ou seja, que estava equipado e agora está sendo movido PARA O INVENTÁRIO, está sendo movido para um SLOT VAZIO
				return true # Se o slot no inventário estiver vazio retorna verdadeiro.
			
			if data.item != null and item_icon.item != null: # Se o SLOT NO INVENTÁRIO NÃO ESTIVER VAZIO ele entra nessa condição
				if data.item.item_type == item_icon.item.item_type and data.owner.get_requeriments(item_icon.item): # Se ele atender a essas condições significa que ele vai realizar uma troca do item que estava no inventário com o item que estava equipado, para atender essas condições os items precisam ser DO MESMO TIPO E ALÉM DISSO O ITEM QUE ESTAVA NO INVENTÁRIO PRECISA ATENDER AOS REQUERIMENTOS PARA SER EQUIPADO
					return true
				else: # Os items não são do mesmo tipo OU os items são do mesmo tipo MAS o item do inventário não atende aos requerimentos para ser equipado
					return false
					
	return false
	

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
	$ItemIcon._on_mouse_entered()
