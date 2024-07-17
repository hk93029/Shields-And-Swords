extends Character
class_name Zombie

@export var death_experience_min: int = 30 #Enemy
@export var death_experience_max: int = 40 #Enemy
@export var speed: int = 50

var damage_base: int
var blocking_chance: int = 30
var is_dead: bool = false
var target_body = null
var start_position: Vector2 = Vector2.ZERO

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	ready_character()
	hp_bar.max_value = max_health
	hp_bar.value = max_health

	start_position = global_position
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	

func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed
	
	if velocity.x != 0 or velocity.y != 0:
		animation_player.play("walk")
	
	move_and_slide()
	
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
			

func recalc_path():
	if target_body != null:
		nav_agent.target_position = target_body.global_position
	else:
		nav_agent.target_position = start_position


func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)


func _on_clickable_area_2d_mouse_exited():
	if Mouse.target_body == self:
		Mouse.reset()


func _on_aggro_range_area_entered(area):
	
	if area.owner.is_in_group("player"):
		target_body = area.owner


func _on_de_agro_range_area_exited(area):
	
	if area.owner == target_body:
		target_body = null


func _on_recalculate_timer_timeout():
	recalc_path()
