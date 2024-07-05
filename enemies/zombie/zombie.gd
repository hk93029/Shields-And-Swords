extends CharacterBody2D

var health: int = 5

func _ready():
	pass


func play_damage_effect():
	print(health)

func play_death_effect():
	print("Morto!")
	queue_free()

func take_damage(damage):
	health = clamp(health-damage, 0, health)
	if health > 0:
		play_damage_effect()
	else:
		play_death_effect()
			
func _on_clickable_area_2d_mouse_entered():
	print("Entered!")
	Mouse.change_state(self)
	GameManager.selector_position = self.global_position
	GameManager.enemy_selected = self
	print(GameManager.enemy_selected)

func _on_clickable_area_2d_mouse_exited():
	Mouse.reset()
	if GameManager.enemy_selected == self:
		GameManager.enemy_selected = null
	print("Exited!")
	print(GameManager.enemy_selected)
