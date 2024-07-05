extends Sprite2D

@onready var body: CharacterBody2D = $"../Player"

func _process(delta):
	self.position = GameManager.selector_position
