class_name EquipmentsAdditionals # Amount of additionals of all equips togheter
extends Resource

@export var HP: int = 100
@export var MP: int = 30

@export var STR: int = 0 # Damage; Regeneration; Use items; 1 str = 2 damage
@export var CONS: int = 0 # HP; Natural Armor; 1 cons = 20 HP
@export var DEX: int = 0 # Evasion chance; Critical chance[ 1 dex = 1.3 critical chance]; Speed of attack
@export var INT: int = 0 # Longest times in buffs; Spells do more damage; Magical defense; Use items; 1 int = 24 MP; 1 int = 2 magical_damage

var critical_chance: float = 0
var blocking_chance: int = 0
var evasion: float = 0
var critical_damage: float = 0
var min_damage: int = 0# dano natural + dano de arma, arma possui dano máximo e mínimo, a cada ataque é recalculado aleatóriamente
var max_damage: int = 0
var damage_base: int = 0 # baseado em STR
var attack_speed: float = 0
var defense: int = 0
var magical_defense: int = 0

# Damage
var physical_damage: int = 0
var extra_damage: int = 0 
var fire_damage: int = 0
var cold_damage: int = 0
var lightning_damage: int = 0
var darkness_damage: int = 0

# Defense
var physical_defense: int = 0
var extra_defense: int = 0
var fire_defense: int = 0
var cold_defense: int = 0
var lightning_defense: int = 0
var darkness_defense: int = 0

