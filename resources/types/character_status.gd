class_name CharacterStatus
extends Node2D

@export var HP: int = 100
@export var MP: int = 30

var critical_chance: float = 0
var blocking_chance: int = 0
var evasion: float = 0
var critical_damage: float = 0
var min_damage: int = 0# dano natural + dano de arma, arma possui dano máximo e mínimo, a cada ataque é recalculado aleatóriamente
var max_damage: int = 0
var base_damage: int = 0 # baseado em STR
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
