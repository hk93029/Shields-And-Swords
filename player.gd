extends CharacterBody2D

var speed = 300
var click_position = Vector2()
var target_position = Vector2()

@onready var sprite: Sprite2D = $Sprite2D

@onready var animation_tree: AnimationTree = get_node("AnimationTree")



######
var max_zoom_camera: Vector2 = Vector2(1.3, 1.3)
var min_zoom_camera: Vector2 = Vector2(0.6, 0.6)
var lerp_zoom_camera = 0.2

#####
@onready var camera: Camera2D = $Camera2D
var random_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var random_strength: float = 30.0
@export var shake_fade: float = 5.0
#####

var position_arrived: bool = true
var is_running: bool = false
var is_attacking: bool = false

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	var img = get_viewport().get_texture().get_image()
	
	var tex = ImageTexture.create_from_image(img)
	
	sprite.texture = tex
	if Input.is_action_just_pressed("ui_accept"):
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	if shake_strength >= 1.7: #shake_strength é basicamente o tempo que a camera vai ficar tremendo
		shake_strength = lerpf(shake_strength, 0, shake_strength * delta)
		camera.offset = random_offset()
	else:
		camera.offset = lerp(camera.offset, Vector2(0, 0), delta * 1.1)
		


	if Input.is_action_just_pressed("left_click") or Input.is_action_pressed("left_click"):
		click_position = get_global_mouse_position()+Vector2(0, 10)
		position_arrived = false
	if position.distance_to(click_position) > 20 and !position_arrived:
		print("aaa")
		print(click_position)
		print(self.position)
		target_position = (click_position - position).normalized()
		velocity = target_position * speed
		if velocity.x < 0:
			$Sprite.scale.x = 1
		elif velocity.x > 0:
			$Sprite.scale.x = -1
		animation_tree["parameters/Transition/transition_request"] = "run"
	elif position.distance_to(click_position) <= 3:
		position_arrived = true
		velocity = Vector2(0, 0)
		if animation_tree["parameters/Transition/current_state"] == "run":
			print(animation_tree["parameters/Transition/current_state"])
			animation_tree["parameters/Transition/transition_request"] = "idle"
			is_running = false


	move_and_slide()

func _input(event):
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



func apply_shake() -> void:
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(random_generator.randf_range(-shake_strength, shake_strength), random_generator.randf_range(-shake_strength, shake_strength)-10)


# Vai ativar animação de ataque quando:
# Estiver em estado "atacando"
# O HP do ser atacado for >= 0

func attack() -> void:
	if is_attacking:
		return
	
	
	
