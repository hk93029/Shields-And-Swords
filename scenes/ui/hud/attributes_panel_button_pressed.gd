extends TextureButton


func _on_pressed():
	Events.emit_signal("attributes_panel_button_pressed")
