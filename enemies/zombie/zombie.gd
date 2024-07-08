extends CharacterBody2D

var health: int = 5
var max_health: int = health
var damage_digit_prefab: PackedScene
@onready var damage_digit_maker: Marker2D = $DamageDigitMarker

func _ready():
	$HPBar.value = 100
	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")


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
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = damage_count
	
	
	if damage_digit_maker != null:
		damage_digit.global_position = damage_digit_maker.global_position
	else:
		damage_digit.global_position = global_position - Vector2(0, 130.218)
	
	get_parent().add_child(damage_digit)
	
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
