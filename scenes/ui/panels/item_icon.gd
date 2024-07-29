extends TextureRect

var item: Item
var tooltip_item: Control
@export var origin_slot: String = "Inventory"
	
	
func _get_drag_data(at_position): # Dado que será retornado quando clicar duas vezes e arrastar. NÃO é o dado visual, é o dado real que será ARMAZENADO na área de DROP
	if texture != null:
		Mouse.is_dragging = true
		set_drag_preview(get_preview()) # set_drag_preview adiciona o item gerado como filho do nó Control que esteja mais no topo, ou seja, o nó Control mais elevado, que está acima de todos
		return self # Esse vai ser o data
	
	
func get_preview(): # preview é apenas algo VISUAL, ele define o que será VISTO quando o item estiver sendo arrastado
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	preview_texture.position = Vector2(-15,-15)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview


func _on_mouse_entered():
	if item != null:
		for child in get_parent().get_children():
			if child.name.begins_with("ToolTip"):
				get_parent().remove_child(child)
		tooltip_item = TooltipManager.generate_tooltip(item)
		$Timer.start(0.5)

func _on_mouse_exited():
	get_parent().remove_child(tooltip_item)
	$Timer.stop()
	
func _on_timer_timeout():
	if item != null:
		get_parent().add_child(tooltip_item)
