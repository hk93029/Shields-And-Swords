extends CharacterBody2D

var health: int = 5
var max_health: int = health

func _ready():
	$HPBar.value = 100
	

func set_percent_value_int(value: int) -> void:
	$HPBar.value = value
	

func play_damage_effect():
	print(health)

func play_death_effect():
	print("Morto!")
	queue_free()

func damage(damage_count: int) -> void:
	health = clamp(health-damage_count, 0, health)
	set_percent_value_int(float(health)/max_health * 100)
	if health > 0:
		play_damage_effect()
	else:
		if self == Mouse.target_body:
			Mouse.reset()
		queue_free()
			
func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)


func _on_clickable_area_2d_mouse_exited():
	Mouse.reset()
