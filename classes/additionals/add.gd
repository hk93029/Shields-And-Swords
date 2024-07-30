class_name Add
extends Resource

enum Type{EMPTY, ATTRIBUTE, COMBAT_PERFORMACE, DAMAGE, DEFENSE, BOOST}
var type: Type

func _init():
	type = Type.EMPTY
