extends Camera2D

var random_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var random_strength: float = 30.0
@export var shake_fade: float = 5.0
#####

var is_shaking: bool = false

func _process(delta):
	# Treme a câmera ao utilizar skill de dano ( apenas um teste )
	if is_shaking:
		if shake_strength >= 1.7: #shake_strength é basicamente o tempo que a camera vai ficar tremendo
			shake_strength = lerpf(shake_strength, 0, shake_strength * delta)
			offset = random_offset()
		else:
			offset = lerp(offset, Vector2(0, 0), delta * 1.1)
			is_shaking = false


func apply_shake() -> void:
	shake_strength = random_strength
	print(shake_strength)
	is_shaking = true

func random_offset() -> Vector2:
	return Vector2(random_generator.randf_range(-shake_strength, shake_strength), random_generator.randf_range(-shake_strength, shake_strength)-10)
