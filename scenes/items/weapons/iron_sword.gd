class_name WeaponComponent
extends Sprite2D

@export var damage: Damage

@export_category("Weapon Adds")  
@export var adds: ItemAdds
@export var STR: int = 0
@export var INT: int = 0
@export var CONS: int = 0
@export var DEX: int = 0

@export var critical_chance: float = 0.0
@export var critical_damage: float = 0.0
@export var attack_speed: float = 0.0

@export var Hp: int = 0
@export var mp: int = 0

@export_category("Damages")
@export var physical_damage_min: int
@export var physical_damage_max: int
@export var extra_damage: int = 0 # Dano adicional que não é de nenhum tipo mágico, é somado ao dano padrão da arma(physical_damage)
@export var fire_damage: int = 0
@export var cold_damage: int = 0
@export var lightning_damage: int = 0
@export var dark_damage: int = 0




func _ready():
	pass
