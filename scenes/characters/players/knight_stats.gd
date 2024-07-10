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

var level: int = 1
var exp_necessary: Array[int] = [0, 100, 230, 400, 620, 920, 1300, 2200, 3200, 4500, 5700, 6900] # para lvl 1 precisa de 100xp para lvl 2 precisa de 130...
var current_exp: int = 0
var level_atribute_points: int = 0

@onready var weapon = %Weapon
@onready var weapon_damage: Damage = %Weapon.damage
@onready var weapon_adds: ItemAdds = %Weapon.adds

var damage_base
var damage: Damage = Damage.new()

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	recalculate_attributes()
#	recalculate_items_atributes()

func recalculate_attributes() -> void: # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	HP = weapon_adds.hp + (constitution+weapon_adds.CONS)*20
	MP = weapon_adds.mp + (intelligence+weapon_adds.INT)*24
	critical_chance = weapon_adds.critical_chance + (dexterity+weapon_adds.DEX)*1.3
	critical_damage = weapon_adds.critical_damage + (dexterity+weapon_adds.DEX)*3
	evasion_chance = (dexterity+weapon_adds.DEX)*1.3
	speed_of_attack = (0.6 + (dexterity+weapon_adds.DEX)*0.1) if  (0.6 + (dexterity+weapon_adds.DEX)*0.1) <= 6 else 6
	
	damage_base = (weapon_adds.STR+strenght)*2


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


func is_critical_damage() -> bool:
	
	var probability = rng.randi_range(0, 100)
	if probability <= critical_chance:
		return true
	return false


func level_up():
	
	level += 1
	level_atribute_points += 3
	HUD.update_experience_bar(exp_necessary[level-1], exp_necessary[level])
	HUD.update_level_indicator(level, level+1) # (current_level, next_level)

func update_exp(exp: int) -> void:
	
	current_exp += exp
	if (level <= 50 and current_exp >= exp_necessary[level]):
		level_up()
	
	HUD.experience_bar.value = current_exp
	
