class_name Character
extends CharacterBody2D

@export var health: int = 60
@export var max_health: int = health
@onready var damage_digit_maker: Marker2D = %DamageDigitMarker
@export var hp_bar: HPBar
@export var armor: Armor
@export var ring: Ring
@export var amulet: Amulet
@onready var weapon: Weapon = %Weapon

enum {ARMOR_ADDS, RING_ADDS, AMULET_ADDS, WEAPON_ADDS}

var armor_adds: ItemAdds = ItemAdds.new()
var armor_defense: Defense = Defense.new()
var ring_adds: ItemAdds = ItemAdds.new()
var amulet_adds: ItemAdds = ItemAdds.new()
var weapon_adds: ItemAdds = ItemAdds.new()
var weapon_damage: Damage = Damage.new()

var items_adds: Array[ItemAdds]

var damage_digit_prefab: PackedScene
var critical_damage_digit_prefab: PackedScene
var blocked_damage_digit_prefab: PackedScene
var evaded_damage_digit_prefab: PackedScene

@export var attributes: CharacterAttributes

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var damage_received : int

func _ready():
	add_to_group("character", true)
	
	hp_bar.max_value = max_health
	hp_bar.value = health
	
	if armor != null:
		items_adds[ARMOR_ADDS] = armor.adds
		armor_defense = armor.defense
	if ring != null:
		items_adds[RING_ADDS] = ring.adds
	if amulet != null:
		items_adds[AMULET_ADDS] = amulet.adds
	if weapon != null:
		items_adds[WEAPON_ADDS] = weapon.adds
		weapon_adds = weapon.adds
		weapon_damage = weapon.damage
	
	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")
	critical_damage_digit_prefab = preload("res://misc/damage_digit/critical_damage_digit.tscn")
	blocked_damage_digit_prefab = preload("res://misc/damage_digit/blocked_damage_digit.tscn")
	evaded_damage_digit_prefab =  preload("res://misc/damage_digit/evaded_damage_digit.tscn")

	calculate_attributes()

func calculate_attributes() -> void: # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	attributes.HP = get_total_hp()
	attributes.MP = get_total_mp()
	attributes.critical_chance = get_total_critical_chance()
	attributes.critical_damage = get_total_critical_damage()
	attributes.evasion = get_total_evasion()
	attributes.speed_of_attack = get_total_attack_speed()
	
	attributes.damage_base = get_total_damage_base() # dano base apenas calculando a força do personagem, desconsiderando o dano da arma e danos extras da arma | Apenas a arma pode ter addicionais de dano, o máximo que os outros items podem contribuir com dano é tendo o atributo STR

func get_total_hp():
	
	var total_hp = 0
	var total_cons = attributes.constitution
	for item_add in items_adds:
		total_hp += item_add.hp
		total_cons += item_add.CONS
	
	return total_hp + total_cons*20 # 1 cons = 20 hp


func get_total_mp():
	
	var total_mp = 0
	var total_int = attributes.intelligence
	for item_add in items_adds:
		total_mp += item_add.mp
		total_int += item_add.INT
	
	return total_mp + total_int*24 # 1 int = 24 mp


func get_total_critical_chance():
	
	var total_critical_chance = 0
	var total_dex = attributes.dexterity
	for item_add in items_adds:
		total_critical_chance += item_add.critical_chance
		total_dex += item_add.DEX
		
	return total_critical_chance + total_dex*0.33 # 1 dex = 0.33 critical chance
	

func get_total_critical_damage():
	
	var total_critical_damage = 0
	var total_str = attributes.strenght
	
	for item_add in items_adds:
		total_critical_damage += item_add.total_critical_damage
		total_str += item_add.STR
		
	return total_critical_damage + total_str*3 # 1 str = 3 critical_damage


func get_total_evasion():
	
	var total_evasion = 0
	var total_dex = attributes.dexterity
	
	for item_add in items_adds:
		total_evasion += item_add.evasion
		total_dex += item_add.DEX
		
	return total_evasion + total_dex*1.3


func get_total_attack_speed():
	
	var total_attack_speed = 0
	var total_dex = attributes.dexterity
	for item_add in items_adds:
		total_attack_speed += item_add.attack_speed
		total_dex += item_add.DEX
	
	total_attack_speed = 1 + total_attack_speed + 5 * easeInSine(float(total_dex)/100)
	if total_attack_speed > 6:
		total_attack_speed = 6
		
	return total_attack_speed
	

func get_total_damage_base():
	
	var total_str = attributes.strenght
	for item_add in items_adds:
		total_str += item_add.STR
	
	return total_str*2


func get_damage() -> Damage:
	var damage: Damage = Damage.new()
	var physical_damage = attributes.damage_base + weapon_damage.extra_damage +rng.randi_range(weapon.physical_damage_min, weapon.physical_damage_max)

	if is_critical_damage():
		physical_damage = physical_damage + (float(physical_damage)/100)*attributes.critical_damage
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
	
	damage.physical_damage = physical_damage
	damage.extra_damage = weapon_damage.extra_damage
	damage.fire_damage = weapon_damage.fire_damage
	damage.cold_damage = weapon_damage.cold_damage
	damage.lightning_damage = weapon_damage.lightning_damage
	damage.dark_damage = weapon_damage.dark_damage
	
	return damage
	
	
func is_critical_damage() -> bool:
	
	var probability = rng.randi_range(0, 100)
	if probability <= attributes.critical_chance:
		return true
	return false

func get_target_body():
	pass

func is_evaded_hit() -> bool:
	
	var probability = rng.randi_range(0, 100)
	var target_body = get_target_body()
	if target_body != null and target_body.is_in_group("character") and probability <= (target_body.attributes.evasion - (attributes.dexterity*1.3)):
		return true	
	return false
	
func is_blocked_hit() -> bool:
	
	var probability = rng.randi_range(0, 100)
	var target_body = get_target_body()
	if target_body !=null and target_body.is_in_group("character") and probability <= target_body.blocking_chance:
		return true
	return false		
	
# from: https://easings.net/#easeInSine
func easeInSine(x: float) -> float: # 0 -> 1
	return 1 - cos((x * PI) / 2)

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
	health = clamp(health-damage_received, 0, health)
	set_percent_value_int(float(health)/max_health * 100)
	
	
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
		die()


func die():
	#get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	#queue_free()
	#print("XD")
	pass
			
func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)


func _on_clickable_area_2d_mouse_exited():
	Mouse.reset()
