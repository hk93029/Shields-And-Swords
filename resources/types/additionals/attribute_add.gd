class_name AttributeAdd
extends Add

enum Improvment{STR, INT, CONS, DEX, HP, MP}


@export var improvment: Improvment
@export var value: int

func _init():
	type = Type.ATTRIBUTE
	improvment = Improvment.STR
	value = 1
