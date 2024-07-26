extends Sprite2D

@export var weapon_settings: Weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = weapon_settings.sprite


