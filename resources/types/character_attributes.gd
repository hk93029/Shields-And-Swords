class_name CharacterAttributes
extends Resource

@export var HP: int = 100
@export var MP: int = 30
@export var strenght: int = 6 # Damage; Regeneration; Use items; 1 str = 2 damage
@export var constitution: int = 6 # HP; Natural Armor; 1 cons = 20 HP
@export var dexterity: int = 4 # Evasion chance; Critical chance[ 1 dex = 1.3 critical chance]; Speed of attack
@export var intelligence: int = 2 # Longest times in buffs; Spells do more damage; Magical defense; Use items; 1 int = 12 MP; 1 int = 2 magical_damage

var critical_chance: float = 2
var blocking_chance: int
var evasion: float = 2
var critical_damage: float = 3
var min_damage: int = 1# dano natural + dano de arma, arma possui dano máximo e mínimo, a cada ataque é recalculado aleatóriamente
var max_damage: int = 1
var damage_base: int = 1
var speed_of_attack: float = 1
var defense: int
var magical_defense: int
