class_name Player
extends Character

enum State { MOVE, ATTACK}

var speed: Vector2 = Vector2(300, 300)

var last_mouse_position = null
var target_body_clicked = null
var state = State.MOVE
var attack_range = 20
var player_damage = 1

var click_position: Vector2 = Vector2()
var target_position: Vector2 = Vector2()

@onready var camera: Camera2D = get_node("Camera")
@onready var sprite: Node2D = get_node("Sprite")

@onready var animation_tree: AnimationTree = get_node("AnimationTree")

@onready var tile_map: TileMap = get_tree().get_first_node_in_group("tilemap") #$"../TileMap"

@onready var recalculate_path_timer: Timer = $Navigation/RecalculatePathTimer

######
var max_zoom_camera: Vector2 = Vector2(1.3, 1.3)
var min_zoom_camera: Vector2 = Vector2(0.6, 0.6)
var lerp_zoom_camera = 0.2

#####

# Navigation Agent Config
@export var nav_agent: NavigationAgent2D
var target_node = null


#####
var position_arrived: bool = true
var is_running: bool = false
var is_on_attack: bool = false
var can_attack: bool = true

var last_mouse_pos = null

var enemies_in_range: Array

func _ready():
	ready_character()
	animation_tree.active = true
	nav_agent.path_desired_distance = 20
	nav_agent.target_desired_distance = 4
	UI.player_ref = self

func get_target_body():
	return target_body_clicked

func _input(event):

	if event is InputEventMouse:
		last_mouse_pos = get_global_mouse_position()
		
		var movement_condition = !Mouse.is_on_ui and !Mouse.is_dragging and tile_map != null and (tile_map.is_on_ground(last_mouse_pos))
		if (event.is_action_pressed("left_click") or Input.is_action_pressed("left_click")) and movement_condition:
			
			if Mouse.target_body != target_body_clicked:
				target_body_clicked = Mouse.target_body
			
			if target_body_clicked != null:
				nav_agent.target_position = target_body_clicked.position
				
				if target_body_clicked.is_in_group("walking_creature"):
					recalculate_path_timer.start() # Só há necessidade de utilizar o timer de recalculo quando o alvo desejado se movimentar
				else:
					recalculate_path_timer.stop()
					
			elif position.distance_to(last_mouse_pos) >= 50: # target_body_clicked == null
					nav_agent.target_position = last_mouse_pos
				
func _physics_process(delta):

	if (target_body_clicked != null):
		var direction_to_target = position.direction_to(target_body_clicked.position)
		var distance_limit
		
		if abs(direction_to_target.dot(Vector2(scale.x, 0))) > 0.7:
			distance_limit = 80 # + weapon_range
		else:
			if target_body_clicked.position.y > position.y:
				distance_limit = 30
			else:
				distance_limit = 10
		
		if (target_body_clicked.is_in_group("enemy") and nav_agent.distance_to_target() <= distance_limit):
			#print(nav_agent.distance_to_target())
			animation_tree["parameters/Transition/transition_request"] = "idle"
			
			
			if target_body_clicked.position.x < position.x:
				sprite.scale.x = 1
			elif target_body_clicked.position.x > position.x:
				sprite.scale.x = -1
				
			if can_attack and !target_body_clicked.is_dead:
				attack()
			
			return
			
		if (target_body_clicked.is_in_group("npc") and nav_agent.distance_to_target() <= 50):
			play_dialog_action()
			return
		
		if (target_body_clicked.is_in_group("item") and nav_agent.distance_to_target() <= 10):
			play_pickup_item_action()
			return
			
	animation_tree["parameters/Attack1_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/Attack2_OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	can_attack = true

	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed
	

#	print("Position x:", str(position.x), "Next node position: ", str(nav_agent.get_next_path_position().x))

	if (nav_agent.distance_to_target() <= 30):
		velocity = Vector2(0, 0)
		nav_agent.target_position = self.position
	
	
	if velocity.x < 0:
		sprite.scale.x = 1
	elif velocity.x > 0:
		sprite.scale.x = -1
	

	if velocity.x != 0 and velocity.y != 0:
		animation_tree["parameters/Transition/transition_request"] = "run"
	else:
		animation_tree["parameters/Transition/transition_request"] = "idle"
	
	#print(velocity.x)
	move_and_slide()


func handle_camera(delta):
	if Input.is_action_just_pressed("zoom_in_camera"):
		if camera.zoom < max_zoom_camera:
			camera.zoom = lerp(camera.zoom, camera.zoom+Vector2(0.01,0.01), lerp_zoom_camera*delta)
	elif Input.is_action_just_pressed("zoom_out_camera"):
		if camera.zoom > min_zoom_camera:
			camera.zoom = lerp(camera.zoom, camera.zoom-Vector2(0.01,0.01), lerp_zoom_camera*delta)

func hit(): # hit está sendo chamado diretamente da animação, ou seja, só o ato de animar o attack dele, automaticamente já faz ele infligir dano ao alvo
	if not target_body_clicked:
		return
		
	target_body_clicked.hurt(get_damage())#(player_damage)
	if target_body_clicked.is_dead:
		target_body_clicked = null
		nav_agent.target_position = self.position
		

# Vai ativar animação de ataque quando:
# Estiver em estado "atacando"
# O HP do ser atacado for >= 0
func attack() -> void:
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
		
# Função que deve ser chamada no final de toda animação de ataque
func set_can_attack_to_true():
	can_attack = true

func on_animation_finished(name: String) -> void:
	print(name)
	

func recalc_path(target_body):
	if target_body_clicked != null:
		nav_agent.target_position = target_body.position
	
	
func _on_attack_area_2d_body_entered(body):

	if body.is_in_group("enemy"):
		position_arrived = true
		click_position = position
		velocity = Vector2(0, 0)


func play_dialog_action():
	pass

func play_pickup_item_action(): # Coisas do item como comportamentos relacionados ao drop, quando ele é dropado e etc são manipulados nele
	Mouse.can_player_move = false
	# Animation ## ao terminar animação Mouse.can_player_move retorna para verdadeiro
	pass


func handle_skill_animations(skill):
	match skill:
		0: # Player.physical_skill_area
			pass
		1: # Player.physical_skill_direct
			pass
		3: # Player.buff_skill
			pass

func append_enemy(body):
	if body.is_in_group("enemy"):
		enemies_in_range.append(body)

func remove_enemy(body):
	if enemies_in_range.has(body):
		enemies_in_range.erase(body)

func _get_target_body():
	return target_body_clicked

func _on_recalculate_path_timer_timeout():
#	print("ué")
	recalc_path(target_body_clicked)
