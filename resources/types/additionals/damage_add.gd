class_name DamageAdd
extends Add

enum Improvment{EXTRA, FIRE, COLD, LIGHTNING, DARKNESS}
@export var improvment: Improvment
@export var value: int

func _init():
	type = Type.DAMAGE
	improvment = Improvment.EXTRA
	value = 1
