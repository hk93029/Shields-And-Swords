class_name Character
extends CharacterBody2D


enum AttributeType { STR, DEX, CONS, INT}

const MAX_BLOCKING_CHANCE: int = 33

@export var char_attributes: CharacterAttributes

var health: int
var max_health: int
@export var base_hp: int = 100
@export var base_mp: int = 20
@export var damage_digit_maker: Marker2D
@export var hp_bar: HPBar
@export var armor: Armor # = %Armor
@export var ring: Ring # = %Ring
@export var amulet: Amulet # = %Amulet
@export var weapon: Weapon

var weapon_adds: Array[Add]
var armor_adds: Array[Add]
var ring_adds: Array[Add]
var amulet_adds: Array[Add]

var damage_digit_prefab: PackedScene
var critical_damage_digit_prefab: PackedScene
var blocked_damage_digit_prefab: PackedScene
var evaded_damage_digit_prefab: PackedScene

var char_stats: CharacterStatus = CharacterStatus.new()
var equips_adds: EquipmentsAdditionals # Amount of all equips adds togheter
#var skill_adds: SkillAdditionals

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var damage_received : int

signal critical_damage_received
signal blocked_damage_received
signal evaded_damage_received


func ready_character():
	add_to_group("character", true)
	char_stats = CharacterStatus.new()
	equips_adds = EquipmentsAdditionals.new()
#	char_attributes = CharacterAttributes.new()

	if armor != null:
		equip_item(armor)
#		armor_adds = armor.adds
	if ring != null:
		equip_item(ring)
		#ring_adds = ring.adds
	if amulet != null:
		equip_item(amulet)
		#amulet_adds = amulet.adds
	if weapon != null:
		equip_item(weapon)
		#weapon_adds = weapon.adds

	

	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")
	critical_damage_digit_prefab = preload("res://misc/damage_digit/critical_damage_digit.tscn")
	blocked_damage_digit_prefab = preload("res://misc/damage_digit/blocked_damage_digit.tscn")
	evaded_damage_digit_prefab =  preload("res://misc/damage_digit/evaded_damage_digit.tscn")

	recalculate_status()


func recalculate_status() -> void: # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	char_stats.HP = base_hp + equips_adds.HP + (char_attributes.CONS+equips_adds.CONS)*20
	char_stats.MP = base_mp + equips_adds.MP + (char_attributes.INT+equips_adds.INT)*24
	char_stats.critical_chance = equips_adds.critical_chance + (char_attributes.DEX+equips_adds.DEX)*1.3
	char_stats.blocking_chance = equips_adds.blocking_chance
	char_stats.critical_damage = equips_adds.critical_damage + (char_attributes.STR+equips_adds.STR)*3
	char_stats.evasion = equips_adds.evasion + (char_attributes.DEX+equips_adds.DEX)*1.3
	char_stats.attack_speed = equips_adds.attack_speed + 1 + 5 * easeInSine(float(char_attributes.DEX+equips_adds.DEX)/100)
	char_stats.base_damage = (equips_adds.STR+char_attributes.STR)*2
	max_health = char_stats.HP
	health = max_health
	hp_bar.max_value = max_health
	hp_bar.value = health
	
	

func update_hp() -> void:
	char_stats.HP = 100 + equips_adds.HP + (char_attributes.CONS+equips_adds.CONS)*20	
	
func update_mp() -> void:
	char_stats.MP = 20 + equips_adds.MP + (char_attributes.INT+equips_adds.INT)*24
			
func update_critical_chance() -> void:
	char_stats.critical_chance = equips_adds.critical_chance + (char_attributes.DEX+equips_adds.DEX)*1.3

func update_blocking_chance() -> void:
	char_stats.blocking_chance = clamp(equips_adds.blocking_chance, 0,  MAX_BLOCKING_CHANCE)


func update_critical_damage() -> void:
	char_stats.critical_damage = equips_adds.critical_damage + (char_attributes.STR+equips_adds.STR)*3
	
func update_evasion() -> void:
	char_stats.evasion = equips_adds.evasion + (char_attributes.DEX+equips_adds.DEX)*1.3
		
func update_attack_speed() -> void:
	char_stats.attack_speed = equips_adds.attack_speed + 1 + 5 * easeInSine(float(char_attributes.DEX+equips_adds.DEX)/100)
	
func get_attack_speed() -> float:
	return char_stats.attack_speed

func update_base_damage() -> void:
	char_stats.base_damage = (equips_adds.STR+char_attributes.STR)*2

func update_defense(type):
	
	match type:
		"extra_defense":
			char_stats.extra_defense = equips_adds.extra_defense
		"fire_defense":
			char_stats.fire_defense = equips_adds.fire_defense
		"cold_defense":
			char_stats.cold_defense = equips_adds.cold_defense
		"lightning_defense":
			char_stats.lightning_defense = equips_adds.lightning_defense
		"darkness_defense":
			char_stats.darkness_defense = equips_adds.darkness_defense

func update_damage(type):
	
	match type:
		"extra_damage":
			char_stats.extra_damage = equips_adds.extra_damage
		"fire_damage":
			char_stats.fire_damage = equips_adds.fire_damage
		"cold_damage":
			char_stats.cold_damage = equips_adds.cold_damage
		"lightning_damage":
			char_stats.lightning_damage = equips_adds.lightning_damage
		"darkness_damage":
			char_stats.darkness_damage = equips_adds.darkness_damage


func increaseAttribute(type: String, amount: int) -> void:
	
	match type:
		"STR":
			char_attributes.STR += amount
			update_critical_damage()
			update_base_damage()
			
		"DEX":
			char_attributes.DEX += amount
			update_critical_chance()
			update_evasion()
			update_attack_speed()

		"CONS":
			char_attributes.CONS += amount
			update_hp()

		"INT":
			char_attributes.INT += amount
			update_mp()


func decreaseAttribute(type: String, amount: int) -> void:
	
	match type:
		"STR":
			char_attributes.STR -= amount
			update_critical_damage()
			update_base_damage()
			
		"DEX":
			char_attributes.DEX -= amount
			update_critical_chance()
			update_evasion()
			update_attack_speed()
			
		"CONS":
			char_attributes.CONS -= amount
			update_hp()
			
		"INT":
			char_attributes.INT -= amount
			update_mp()
						
	
# from: https://easings.net/#easeInSine
func easeInSine(x: float) -> float: # 0 -> 1
	return 1 - cos((x * PI) / 2)


func apply_item_add_effect(add, command):
	if add.type == Add.Type.EMPTY:
		return
	
	var remove_or_add: int
	match command:
		"EQUIP":
			remove_or_add = 1
		"UNEQUIP":
			remove_or_add = -1
	
	if add.type == Add.Type.ATTRIBUTE:
		
		match add.improvment:
			AttributeAdd.Improvment.STR:
				equips_adds.STR += add.value*remove_or_add
				update_critical_damage()
				update_base_damage()

			AttributeAdd.Improvment.INT:
				equips_adds.MP += add.value*remove_or_add
				update_mp()

			AttributeAdd.Improvment.CONS:
				equips_adds.CONS += add.value*remove_or_add
				update_hp()

			AttributeAdd.Improvment.DEX:
				equips_adds.DEX += add.value*remove_or_add
				update_critical_chance()
				update_evasion()
				update_attack_speed()

			AttributeAdd.Improvment.HP:
				equips_adds.HP += add.value*remove_or_add
				update_hp()

			AttributeAdd.Improvment.MP:
				equips_adds.MP += add.value*remove_or_add
				update_mp()

	elif add.type == Add.Type.COMBAT_PERFORMACE:
		
		match add.improvment:
			CombatPerformaceAdd.Improvment.CRITICAL_CHANCE:
				equips_adds.critical_chance += add.value*remove_or_add
				update_critical_chance()

			CombatPerformaceAdd.Improvment.BLOCKING_CHANCE:
				equips_adds.blocking_chance += add.value*remove_or_add
				update_blocking_chance()

			CombatPerformaceAdd.Improvment.CRITICAL_DAMAGE:
				equips_adds.critical_damage += add.value*remove_or_add
				update_critical_damage()

			CombatPerformaceAdd.Improvment.ATTACK_SPEED:
				equips_adds.attack_speed += add.value*remove_or_add
				update_attack_speed()

			CombatPerformaceAdd.Improvment.EVASION:
				equips_adds.evasion += add.value*remove_or_add
				update_evasion()

	elif add.type == Add.Type.DAMAGE:
		
		match add.improvment:
			DamageAdd.Improvment.EXTRA:
				equips_adds.extra_damage += add.value*remove_or_add
				update_damage("extra_damage")
				
			DamageAdd.Improvment.FIRE:
				equips_adds.fire_damage += add.value*remove_or_add
				update_damage("fire_damage")

			DamageAdd.Improvment.COLD:
				equips_adds.cold_damage += add.value*remove_or_add
				update_damage("cold_damage")
				
			DamageAdd.Improvment.LIGHTNING:
				equips_adds.lightning_damage += add.value*remove_or_add
				update_damage("lightning_damage")

			DamageAdd.Improvment.DARKNESS:
				equips_adds.darkness_damage += add.value*remove_or_add
				update_damage("darkness_damage")

	elif add.type == Add.Type.DEFENSE:
		
		match add.improvment:
			DefenseAdd.Improvment.EXTRA:
				equips_adds.extra_defense += add.value*remove_or_add
				update_defense("extra_defense")

			DefenseAdd.Improvment.FIRE:
				equips_adds.fire_defense += add.value*remove_or_add
				update_defense("fire_defense")

			DefenseAdd.Improvment.COLD:
				equips_adds.cold_defense += add.value*remove_or_add
				update_defense("cold_defense")

			DefenseAdd.Improvment.LIGHTNING:
				equips_adds.lightning_defense += add.value*remove_or_add
				update_defense("lightning_defense")

			DefenseAdd.Improvment.DARKNESS:
				equips_adds.darkness_defense += add.value*remove_or_add
				update_defense("darkness_defense")
	

func equip_item(item: Item):
	for add in item.adds:
		apply_item_add_effect(add, "EQUIP")


func unequip_item(item: Item):
	for add in item.adds:
		apply_item_add_effect(add, "UNEQUIP")
		

func get_damage() -> Damage:
	var damage: Damage = Damage.new()
#	var physical_damage = char_status.damage_base + weapon_damage.extra_damage +rng.randi_range(weapon.physical_damage_min, weapon.physical_damage_max)
	damage = weapon.get_weapon_damage()
	damage.physical_damage += char_stats.base_damage
	
	if is_critical_damage():
	#	physical_damage = physical_damage + (float(physical_damage)/100)*attributes.critical_damage
		_get_target_body().emit_signal("critical_damage_received")
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

	if target_body != null and target_body.is_in_group("character") and probability <= (target_body.char_stats.evasion - (char_attributes.DEX*1.3)):
		return true	
	return false
	
func is_blocked_hit() -> bool:
	
	var probability = rng.randi_range(0, 100)
	var target_body = _get_target_body()
	if target_body != null and target_body.is_in_group("character") and probability <= target_body.char_stats.blocking_chance:
		return true
	return false		
	
	
func set_percent_value_int(value: int) -> void:
	$HPBar.value = value
	

func _play_damage_effect():
	#print(health)
	pass
	
func _play_death_effect():
	print("Morto!")
	queue_free()

func hurt(damage: Damage) -> void:

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
		emit_signal("evaded_damage_received")
		damage_digit = evaded_damage_digit_prefab.instantiate()
		damage_digit.value = "Miss!!"	
		damage_received = 0
		
	elif damage.is_blocked:
		emit_signal("blocked_damage_received")
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
	health = clamp(health-damage_received, 0, max_health)
	#set_percent_value_int(float(health)/max_health * 100)
	hp_bar.value = health
	
	if damage_digit_maker != null:
		damage_digit.global_position = damage_digit_maker.global_position
	else:
		damage_digit.global_position = global_position - Vector2(0, 130.218)
	
	get_parent().add_child(damage_digit)
	
	print(damage_received)
	if health > 0:
		_play_damage_effect()
	else:
		_die()


func _die():
	#get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	#queue_free()
	#print("XD")
	pass
			
#func _on_clickable_area_2d_mouse_entered():
#	Mouse.change_state(self)


#func _on_clickable_area_2d_mouse_exited():
#	Mouse.reset()
