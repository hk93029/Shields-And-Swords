class_name Damage # É o dano que é emitido ao adversário, ele é recalculado a cada ataque, pois o adversário pode estar sob efeito de buffs, poções, o dano pode ter sido crítico, etc...
extends Resource

@export var physical_damage: int = 0
@export var extra_damage: int = 0 # Dano adicional que não é de nenhum tipo mágico, é somado ao dano padrão da arma(physical_damage)
@export var fire_damage: int = 0
@export var cold_damage: int = 0
@export var lightning_damage: int = 0
@export var dark_damage: int = 0
var is_critical: bool = false
var had_blocked: bool = false
var is_evaded: bool = false
