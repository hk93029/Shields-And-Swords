extends CharacterBody2D

@export var health: int = 60
@export var max_health: int = health
@export var death_experience_min: int = 30
@export var death_experience_max: int = 40

var damage_digit_prefab: PackedScene
var critical_damage_digit_prefab: PackedScene
var blocked_damage_digit_prefab: PackedScene
var evaded_damage_digit_prefab: PackedScene

var character_attributes: CharacterAttributes = CharacterAttributes.new()

var armor_defense: Defense = Defense.new()
var damage_received : int
var damage_base: int
	

@onready var damage_digit_maker: Marker2D = $DamageDigitMarker

@onready var weapon = %Weapon
@onready var weapon_damage: Damage = %Weapon.damage
@onready var weapon_adds: ItemAdds = %Weapon.adds
@export var attributes: CharacterAttributes = CharacterAttributes.new()

func _ready():
	
	add_to_group("character", true)
	add_to_group("enemy", true)
	add_to_group("walking_creature", true)
	
	$HPBar.value = 100
	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")
	critical_damage_digit_prefab = preload("res://misc/damage_digit/critical_damage_digit.tscn")
	blocked_damage_digit_prefab = preload("res://misc/damage_digit/blocked_damage_digit.tscn")
	evaded_damage_digit_prefab =  preload("res://misc/damage_digit/evaded_damage_digit.tscn")
	#character_attributes.teste()
	recalculate_attributes()

func recalculate_attributes() -> void: # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	attributes.HP = weapon_adds.hp + (attributes.constitution+weapon_adds.CONS)*20
	attributes.MP = weapon_adds.mp + (attributes.intelligence+weapon_adds.INT)*24
	attributes.critical_chance = weapon_adds.critical_chance + (attributes.dexterity+weapon_adds.DEX)*1.3
	attributes.critical_damage = weapon_adds.critical_damage + (attributes.strenght+weapon_adds.STR)*3
	attributes.evasion = (attributes.dexterity+weapon_adds.DEX)*1.3
	print("EVASION: "+str(attributes.evasion))
	attributes.speed_of_attack = (0.6 + (attributes.dexterity+weapon_adds.DEX)*0.1) if  (0.6 + (attributes.dexterity+weapon_adds.DEX)*0.1) <= 6 else 6
	
	damage_base = (weapon_adds.STR+attributes.strenght)*2


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
		damage_digit.value = "MISS!!"	
		damage_received = 0

	elif damage.is_critical:
		damage_digit = critical_damage_digit_prefab.instantiate()
		damage_digit.value = str(damage_received)+"!!"

	elif damage.had_blocked:
		damage_digit = blocked_damage_digit_prefab.instantiate()
		damage_digit.value = "BLOCKED!!"

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
	get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	queue_free()
	print("XD")
			
func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)


func _on_clickable_area_2d_mouse_exited():
	Mouse.reset()
