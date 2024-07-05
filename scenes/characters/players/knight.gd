class_name Player
extends CharacterBody2D

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

var last_mouse_pos = null

func _ready():
	animation_tree.active = true
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4
	HUD.player_node = self

func _input(event):
	
	last_mouse_pos = get_global_mouse_position()
	
	var movement_condition = !Mouse.is_on_hud and tile_map.is_on_ground(last_mouse_pos)
	if (event.is_action_pressed("left_click") or Input.is_action_pressed("left_click")) and movement_condition:
		
		if Mouse.target_body != target_body_clicked:
			target_body_clicked = Mouse.target_body

		if target_body_clicked != null and target_body_clicked.is_in_group("walking_creature"):
			recalculate_path_timer.start() # Só há necessidade de utilizar o timer de recalculo quando o alvo desejado se movimentar
		else:
			nav_agent.target_position = last_mouse_pos
			recalculate_path_timer.stop()

			
func _physics_process(delta):
	
	if (target_body_clicked != null):
		if (target_body_clicked.is_in_group("enemy") and nav_agent.distance_to_target() <= 80):
			attack()
			return
			
		if (target_body_clicked.is_in_group("npc") and nav_agent.distance_to_target() <= 50):
			play_dialog_action()
			return
		
		if (target_body_clicked.is_in_group("item") and nav_agent.distance_to_target() <= 10):
			play_pickup_item_action()
			return
			
	


	
	
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = axis * speed
	
	if velocity.x < 0:
		sprite.scale.x = 1
	elif velocity.x > 0:
		sprite.scale.x = -1
	
	if (nav_agent.distance_to_target() <= 30):
		velocity = Vector2(0, 0)
		nav_agent.target_position = self.position
	
	

	
	print(velocity.x)
	move_and_slide()



func _inputd(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			pass
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			pass



func handle_camera(delta):
	if Input.is_action_just_pressed("zoom_in_camera"):
		if camera.zoom < max_zoom_camera:
			camera.zoom = lerp(camera.zoom, camera.zoom+Vector2(0.01,0.01), lerp_zoom_camera*delta)
	elif Input.is_action_just_pressed("zoom_out_camera"):
		if camera.zoom > min_zoom_camera:
			camera.zoom = lerp(camera.zoom, camera.zoom-Vector2(0.01,0.01), lerp_zoom_camera*delta)



# Vai ativar animação de ataque quando:
# Estiver em estado "atacando"
# O HP do ser atacado for >= 0
func attack() -> void:
	if is_on_attack:
		return
	
	
func recalc_path(target_body):
	if target_body_clicked != null:
		nav_agent.target_position = target_body.position
	
func _on_attack_area_2d_body_entered(body):
	print("OKOKOK") 
	if body.is_in_group("enemy"):
		print("INIMIGO INIMIGO")
		position_arrived = true
		click_position = position
		velocity = Vector2(0, 0)

	pass # Replace with function body.

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


func _on_recalculate_path_timer_timeout():
	print("ué")
	recalc_path(target_body_clicked)
