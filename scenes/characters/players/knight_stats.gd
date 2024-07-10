extends Node

@export var HP: int = 100
@export var MP: int = 30
@export var strenght: int = 6 # Damage; Regeneration; Use items; 1 str = 2 damage
@export var constitution: int = 6 # HP; Natural Armor; 1 cons = 20 HP
@export var dexterity: int = 4 # Evasion chance; Critical chance[ 1 dex = 1.3 critical chance]; Speed of attack
@export var intelligence: int = 2 # Longest times in buffs; Spells do more damage; Magical defense; Use items; 1 int = 12 MP; 1 int = 2 magical_damage

@export var critical_chance: float = 2
var evasion_chance: float = 2
var critical_damage: float = 3
var min_damage: int = 1# dano natural + dano de arma, arma possui dano máximo e mínimo, a cada ataque é recalculado aleatóriamente
var max_damage: int = 1
var speed_of_attack: float = 1
var defense: int
var magical_defense: int

var gold_amount: int
var essence_amount: int

var damage_base

@onready var weapon = %Weapon
@onready var weapon_damage: Damage = %Weapon.damage
@onready var weapon_adds: ItemAdds = %Weapon.adds
var damage: Damage = Damage.new()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	recalculate_attributes()
	recalculate_items_atributes()

func recalculate_attributes(): # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	HP = weapon_adds.hp + (constitution+weapon_adds.CONS)*20
	MP = weapon_adds.mp + (intelligence+weapon_adds.INT)*24
	critical_chance = weapon_adds.critical_chance + (dexterity+weapon_adds.DEX)*1.3
	critical_damage = weapon_adds.critical_damage + (dexterity+weapon_adds.DEX)*3
	evasion_chance = (dexterity+weapon_adds.DEX)*1.3
	speed_of_attack = (0.6 + (dexterity+weapon_adds.DEX)*0.1) if  (0.6 + (dexterity+weapon_adds.DEX)*0.1) <= 6 else 6
	
	damage_base = (weapon_adds.STR+strenght)*2
#	var HP_base = constitution*20
#	var MP_base = intelligence*24
#	var critical_chance_base = dexterity*1.3
#	var critical_damage_base = 33
#	var evasion_chance_base = dexterity*1.3
#	var speed_of_attack_base = (0.6 + dexterity*0.1) if (0.6 + dexterity*0.1) <= 6 else 6
#	damage_base = strenght * 2

#	HP = HP_base # + Weapon.attributes + Armor.atributes + Ring.atributes + Necklace.atributes
#	MP = MP_base
#	critical_chance = critical_chance_base
#	evasion_chance = evasion_chance_base
#	speed_of_attack = speed_of_attack_base

#	critical_damage = critical_damage_base

func recalculate_items_atributes():
	pass


	
func get_damage() -> Damage:
	
	var physical_damage = damage_base + weapon_damage.extra_damage +rng.randi_range(weapon.physical_damage_min, weapon.physical_damage_max)

	if is_critical_damage():
		physical_damage = physical_damage + (float(physical_damage)/100)*critical_damage
		damage.is_critical = true
	else:
		damage.is_critical = false
	
	damage.physical_damage = physical_damage
	damage.extra_damage = weapon_damage.extra_damage
	damage.fire_damage = weapon_damage.fire_damage
	damage.cold_damage = weapon_damage.cold_damage
	damage.lightning_damage = weapon_damage.lightning_damage
	damage.dark_damage = weapon_damage.dark_damage
	
	return damage


func is_critical_damage():
	var probability = rng.randi_range(0, 100)
	if probability <= critical_chance:
		return true
	return false
