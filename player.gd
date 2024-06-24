extends CharacterBody2D

var speed = 300
var click_position = Vector2()
var target_position = Vector2()

@onready var animation_tree: AnimationTree = get_node("AnimationTree")

var is_running: bool
var position_arrived: bool = true

#####
@onready var camera: Camera2D = $Camera2D
var random_generator: RandomNumberGenerator = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var random_strength: float = 30.0
@export var shake_fade: float = 5.0

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_accept"):
		animation_tree["parameters/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	if shake_strength >= 1.7:
		shake_strength = lerpf(shake_strength, 0, shake_strength * delta)
		camera.offset = random_offset()
	else:
		camera.offset = Vector2(0, 0)
		
	

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


func apply_shake():
	shake_strength = random_strength

func random_offset() -> Vector2:
	return Vector2(random_generator.randf_range(-shake_strength, shake_strength), random_generator.randf_range(-shake_strength, shake_strength))
