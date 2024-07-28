class_name BoostAdd
extends Add

enum Improvment{XP, ESSENCE, GOLD}
enum PossibleValues{ B8x = 2, B12x =  12, B20x = 20 } # Boost de 8%, 12% ou 20%

@export var improvment: Improvment
@export var value: PossibleValues

func _init():
	type = Type.BOOST
	improvment = Improvment.XP
	value = PossibleValues.B8x
