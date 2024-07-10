extends CharacterBody2D

var health: int = 5000#60
var max_health: int = health
var damage_digit_prefab: PackedScene
var critical_damage_digit_prefab: PackedScene
var block_damage_digit_prefab: PackedScene
@onready var damage_digit_maker: Marker2D = $DamageDigitMarker

var armor_defense: Defense = Defense.new()
var damage_received : int
	
func _ready():
	$HPBar.value = 100
	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")
	critical_damage_digit_prefab = preload("res://misc/damage_digit/critical_damage_digit.tscn")
	block_damage_digit_prefab = preload("res://misc/damage_digit/block_damage_digit.tscn")

func set_percent_value_int(value: int) -> void:
	$HPBar.value = value
	

func play_damage_effect():
	#print(health)
	pass
func play_death_effect():
	print("Morto!")
	queue_free()

func damage(damage: Damage) -> void:
	var contained_damage
	contained_damage = damage.physical_damage - armor_defense.physical_defense
	damage_received = contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.extra_damage - armor_defense.extra_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.fire_damage - armor_defense.fire_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.cold_damage - armor_defense.cold_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.lightning_damage - armor_defense.lightning_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.dark_damage - armor_defense.dark_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	
	
	# Lose HP logic:
	health = clamp(health-damage_received, 0, health)
	set_percent_value_int(float(health)/max_health * 100)
	
	var damage_digit 
	
	if damage.is_critical:
		damage_digit = critical_damage_digit_prefab.instantiate()
		damage_digit.value = str(damage_received)+"!!"
		print("RECEBEU DANO CRÍTICO!!")
		print(damage_digit.value)
	elif damage.had_blocked:
		damage_digit = block_damage_digit_prefab.instantiate()
		damage_digit.value = "Block!!"
	else:
		damage_digit = damage_digit_prefab.instantiate()
		damage_digit.value = str(damage_received)
	
	
	if damage_digit_maker != null:
		damage_digit.global_position = damage_digit_maker.global_position
	else:
		damage_digit.global_position = global_position - Vector2(0, 130.218)
	
	get_parent().add_child(damage_digit)
	
	print(damage_received)
	if health > 0:
		play_damage_effect()
	else:
		if self == Mouse.target_body:
			Mouse.reset()
		queue_free()
	

func damage_bkp(damage_count: int) -> void:
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
