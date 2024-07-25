class_name CombatPerformaceAdd
extends Add

enum Improvment{CRITICAL_CHANCE, BLOCKING_CHANCE, CRITICAL_DAMAGE, ATTACK_SPEED, EVASION}
@export var improvment: Improvment
@export_range(0, 33) var value: float

func _init():
	type = Type.COMBAT_PERFORMACE
	improvment = Improvment.CRITICAL_CHANCE
	value = 2.0
