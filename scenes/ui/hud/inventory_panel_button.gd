extends TextureButton


func _on_pressed():
	Events.emit_signal("inventory_panel_button_pressed")
