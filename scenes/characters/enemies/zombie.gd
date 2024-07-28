extends Character
class_name Zombie

@export var death_experience_min: int = 30 #Enemy
@export var death_experience_max: int = 40 #Enemy
@export var speed: int = 15

var damage_base: int
var blocking_chance: int = 30
var is_dead: bool = false
var can_attack: bool = true
var is_receiving_critical_damage: bool = false
var target_body = null
var start_position: Vector2 = Vector2.ZERO

var impulse: float = 1

@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine 


func _ready():
	weapon = Weapon.new()
	weapon.physical_damage_min = 10
	weapon.physical_damage_max = 20
	ready_character()

	connect("critical_damage_received", on_critical_damage_received)
	hp_bar.max_value = max_health
	hp_bar.value = max_health

	animation_tree.active = true
	state_machine = animation_tree.get("parameters/playback")
	start_position = global_position
	nav_agent.path_desired_distance = 20
	nav_agent.target_desired_distance = 4
	

func _physics_process(delta):

	if is_dead:
		return
	
	if (target_body != null):
	#	print("TESTE 232323")
		var direction_to_target = position.direction_to(target_body.position)
		var distance_limit
		
		if abs(direction_to_target.dot(Vector2(scale.x, 0))) > 0.7:
			distance_limit = 80+20 # + weapon_range
		else:
			if target_body.position.y > position.y:
				distance_limit = 30
			else:
				distance_limit = 10
		
		if (nav_agent.distance_to_target() <= distance_limit):
		#	print("AAAAAAAAAAAA")
			#print(nav_agent.distance_to_target())
			animation_tree["parameters/Transition/transition_request"] = "idle"
			
			
			if target_body.position.x < position.x:
				$Sprite.scale.x = 1
			elif target_body.position.x > position.x:
				$Sprite.scale.x = -1
				
			if !animation_tree["parameters/Attack2_OneShot/active"] and !animation_tree["parameters/Attack1_OneShot/active"] and !animation_tree["parameters/CriticalDamage1_OneShot/active"]:#and !target_body.is_dead:
				attack()

			return

			
	
	
	
#	impulse = lerp(impulse, 0.0, 0.08)
	animation_tree["parameters/Attack1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/Attack2_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	if !animation_tree["parameters/CriticalDamage1_OneShot/active"]:
		can_attack = true

	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	impulse = lerp(impulse, 0.0001, 0.08)
	velocity = axis * speed * impulse

#	print("Position x:", str(position.x), "Next node position: ", str(nav_agent.get_next_path_position().x))

	if (nav_agent.distance_to_target() <= 30):
		velocity = Vector2(0, 0)
		nav_agent.target_position = self.position
	
	
	if velocity.x < 0:
		$Sprite.scale.x = 1
	elif velocity.x > 0:
		$Sprite.scale.x = -1
	

	if velocity.x != 0 or velocity.y != 0:
		animation_tree["parameters/Transition/transition_request"] = "walk"
	else:
		animation_tree["parameters/Transition/transition_request"] = "idle"
	
	#print(velocity.x)
	move_and_slide()
	
func _play_damage_effect():
	#print(health)
	pass

func _play_death_effect():
	animation_tree["parameters/Attack1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/Attack2_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/CriticalDamage1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	
	animation_tree["parameters/Transition/transition_request"] = "die"
	if self == Mouse.target_body:
		Mouse.reset()

func _die():
	get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	is_dead = true
	_play_death_effect()
			

func recalc_path():
	if target_body != null:
		nav_agent.target_position = target_body.global_position
	else:
		nav_agent.target_position = start_position


func set_can_attack_to_true():
	can_attack = true


func hit(): # hit está sendo chamado diretamente da animação, ou seja, só o ato de animar o attack dele, automaticamente já faz ele infligir dano ao alvo
	if not target_body:
		return
		
	target_body.hurt(get_damage())
	if target_body.is_dead:
		target_body = null
		nav_agent.target_position = self.position
		


func attack():
	can_attack = false
	var rand_num = rng.randi_range(0, 1)
	animation_tree["parameters/Attack1_TimeScale/scale"] = get_attack_speed()
	animation_tree["parameters/Attack2_TimeScale/scale"] = get_attack_speed()
	#print("Speed of attack: "+ str(%Stats.get_attack_speed()))
	match rand_num:
		0:
			animation_tree["parameters/Attack1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		1:
			animation_tree["parameters/Attack2_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		

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

func on_impulse_applied(value):
	impulse = value


func set_is_receiving_critical_damage_to_false():
	is_receiving_critical_damage = false

func on_critical_damage_received():
	animation_tree["parameters/Attack1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/Attack2_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/CriticalDamage1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _get_target_body():
	return target_body
