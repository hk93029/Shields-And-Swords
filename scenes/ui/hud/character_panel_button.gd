extends TextureButton


func _on_pressed():
	Events.emit_signal("character_panel_button_pressed")
