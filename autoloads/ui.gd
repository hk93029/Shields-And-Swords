extends CanvasLayer

var player_ref: Player = null	
var HUD: Control

func _ready():
	HUD = %HUD

func _on_ui_mouse_entered():
	Mouse.is_on_ui = true


func _on_ui_mouse_exited():
	Mouse.is_on_ui = false
	



