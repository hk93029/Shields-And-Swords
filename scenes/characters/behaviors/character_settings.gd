class_name CharacterSettings
extends Node

enum AttributeType { STR, DEX, CONS, INT}

@export var health: int
@export var max_health: int

@export var mana: int
@export var max_mana: int

@export var char_attributes: CharacterAttributes # Atributos: STR, DEX, CONS e INT

@export var armor: Armor
@export var ring: Ring
@export var amulet: Amulet
@export var weapon: Weapon

var char_stats: CharacterStatus # Status é calculado com base nos atributos + items equipados + skills ativas
var equips_adds: EquipmentsAdditionals # Amount of all equips adds togheter
#var skill_adds: SkillAdditionals

func _ready():
	add_to_group("character", true)
	char_stats = CharacterStatus.new()
	equips_adds = EquipmentsAdditionals.new()
	char_attributes = CharacterAttributes.new()
	
	if armor != null:
		equip_item(armor)

	if ring != null:
		equip_item(ring)

	if amulet != null:
		equip_item(amulet)

	if weapon != null:
		equip_item(weapon)

	recalculate_status()


func recalculate_status() -> void: # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	char_stats.HP = 100 + equips_adds.HP + (char_attributes.CONS+equips_adds.CONS)*20
	char_stats.MP = 20 + equips_adds.MP + (char_attributes.INT+equips_adds.INT)*24
	char_stats.critical_chance = equips_adds.critical_chance + (char_attributes.DEX+equips_adds.DEX)*1.3
	char_stats.blocking_chance = equips_adds.blocking_chance
	char_stats.critical_damage = equips_adds.critical_damage + (char_attributes.STR+equips_adds.STR)*3
	char_stats.evasion = equips_adds.evasion + (char_attributes.DEX+equips_adds.DEX)*1.3
	char_stats.attack_speed = equips_adds.attack_speed + 1 + 5 * easeInSine(float(char_attributes.DEX+equips_adds.DEX)/100)
	char_stats.base_damage = (equips_adds.STR+char_attributes.STR)*2
	max_health = char_stats.HP
	

func update_hp() -> void:
	char_stats.HP = 100 + equips_adds.HP + (char_attributes.CONS+equips_adds.CONS)*20	
	max_health = char_stats.HP

func update_mp() -> void:
	char_stats.MP = 20 + equips_adds.MP + (char_attributes.INT+equips_adds.INT)*24


func update_critical_chance() -> void:
	char_stats.critical_chance = equips_adds.critical_chance + (char_attributes.DEX+equips_adds.DEX)*1.3


func update_blocking_chance() -> void:
	char_stats.blocking_chance = equips_adds.blocking_chance


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
