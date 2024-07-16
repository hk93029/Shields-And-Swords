class_name DefenseAdd
extends Add

enum Improvment{EXTRA, FIRE, COLD, LIGHTNING, DARKNESS}
@export var improvment: Improvment
@export var value: int

func _init():
	type = Type.DEFENSE
	improvment = Improvment.EXTRA
	value = 1
