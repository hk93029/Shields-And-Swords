class_name CombatBehavior
extends Node2D

@export var char_stats: CharacterStatus
@export var damage_digit_maker: Marker2D
@export var hp_bar: HPBar

var damage_digit_prefab: PackedScene
var critical_damage_digit_prefab: PackedScene
var blocked_damage_digit_prefab: PackedScene
var evaded_damage_digit_prefab: PackedScene

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var damage_received : int

func _ready():
	
	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")
	critical_damage_digit_prefab = preload("res://misc/damage_digit/critical_damage_digit.tscn")
	blocked_damage_digit_prefab = preload("res://misc/damage_digit/blocked_damage_digit.tscn")
	evaded_damage_digit_prefab =  preload("res://misc/damage_digit/evaded_damage_digit.tscn")


func get_damage() -> Damage:
	var damage: Damage = Damage.new()

##	damage = weapon.get_weapon_damage()
	damage.physical_damage += char_stats.base_damage
	
	if is_critical_damage():
		damage.physical_damage = damage.physical_damage + (float(damage.physical_damage)/100)*char_stats.critical_damage
		damage.is_critical = true
	else:
		damage.is_critical = false
	
	if is_evaded_hit():
		damage.is_evaded = true
	else:
		damage.is_evaded = false
		
	if is_blocked_hit():
		damage.is_blocked = true
	else:
		damage.is_blocked = false
	
	damage.extra_damage += char_stats.extra_damage
	damage.fire_damage += char_stats.fire_damage
	damage.cold_damage += char_stats.cold_damage
	damage.lightning_damage += char_stats.lightning_damage
	damage.darkness_damage += char_stats.darkness_damage
	
	return damage

func set_damage(damage: Damage) -> void:
	var contained_damage
	contained_damage = damage.physical_damage - char_stats.physical_defense
	damage_received = contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.extra_damage - char_stats.extra_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.fire_damage - char_stats.fire_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.cold_damage - char_stats.cold_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.lightning_damage - char_stats.lightning_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	contained_damage = damage.darkness_damage - char_stats.darkness_defense
	damage_received += contained_damage if contained_damage >= 0 else 0
	
	
	var damage_digit 
	
	if damage.is_evaded:
		damage_digit = evaded_damage_digit_prefab.instantiate()
		damage_digit.value = "Miss!!"	
		damage_received = 0
		
	elif damage.is_blocked:
		damage_digit = blocked_damage_digit_prefab.instantiate()
		damage_digit.value = "Blocked!!"
		damage_received = 0

	elif damage.is_critical:
		damage_digit = critical_damage_digit_prefab.instantiate()
		damage_digit.value = str(damage_received)+"!!"

	else:
		damage_digit = damage_digit_prefab.instantiate()
		damage_digit.value = str(damage_received)
	
	# Lose HP logic:
##	health = clamp(health-damage_received, 0, max_health)
##	hp_bar.value = health
	
	if damage_digit_maker != null:
		damage_digit.global_position = damage_digit_maker.global_position
	else:
		damage_digit.global_position = global_position - Vector2(0, 130.218)
	
	get_parent().add_child(damage_digit)
	
##	if health > 0:
##		play_damage_effect()
##	else:
##		if self == Mouse.target_body:
##			Mouse.reset()
##		_die()

func is_critical_damage() -> bool:
	
	var probability = rng.randi_range(0, 100)
	if probability <= char_stats.critical_chance:
		return true
	return false

func _get_target_body(): # Implementado na entidade
	pass

func is_evaded_hit() -> bool:

	var probability = rng.randi_range(0, 100)
	var target_body = _get_target_body()

##	if target_body != null and target_body.is_in_group("character") and probability <= (target_body.char_stats.evasion - (char_attributes.DEX*1.3)):
##		return true	
	return false
	
func is_blocked_hit() -> bool:
	
	var probability = rng.randi_range(0, 100)
	var target_body = _get_target_body()
	if target_body != null and target_body.is_in_group("character") and probability <= target_body.char_stats.blocking_chance:
		return true
	return false		

	
func play_damage_effect():
	#print(health)
	pass
	
func play_death_effect():
	print("Morto!")
	queue_free()

func _die():
	#get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	#queue_free()
	#print("XD")
	pass
			
func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)

func _on_clickable_area_2d_mouse_exited():
	Mouse.reset()
