extends CanvasLayer

var player_ref: Player = null

func _on_skill_bar_mouse_entered():
	Mouse.is_on_hud = true


func _on_skill_bar_mouse_exited():
	Mouse.is_on_hud = false
