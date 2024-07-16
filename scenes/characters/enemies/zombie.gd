extends Character
class_name Zombie

@export var death_experience_min: int = 30 #Enemy
@export var death_experience_max: int = 40 #Enemy

var damage_base: int
var blocking_chance: int = 30
var is_dead: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	ready_character()
	hp_bar.max_value = max_health
	hp_bar.value = max_health

func _play_damage_effect():
	#print(health)
	pass

func _play_death_effect():
	print("Morto!")
	animation_player.play("die")
	if self == Mouse.target_body:
		Mouse.reset()

func _die():
	get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	is_dead = true
	_play_death_effect()
	print("XD")
			
func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)


func _on_clickable_area_2d_mouse_exited():
	if Mouse.target_body == self:
		Mouse.reset()
