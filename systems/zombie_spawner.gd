extends Node2D

@export var max_enemies: int = 3
var zombie_packed_scene: PackedScene

@onready var path_follow_2d: PathFollow2D = %PathFollow2D
# Called when the node enters the scene tree for the first time.
func _ready():
	zombie_packed_scene = preload("res://scenes/characters/enemies/zombie.tscn")
	$Timer.start()

func _on_timer_timeout():
	$Timer.start(2)
	if get_tree().get_nodes_in_group("enemy").size() <= 10:
		var zombie_instance = zombie_packed_scene.instantiate()
		zombie_instance.global_position = get_point()
		get_parent().add_child(zombie_instance)


func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf_range(0, 1)#randf() #randf retorna um valor aleatório entre 0 e 1 == randf_range(0, 1)
	return path_follow_2d.global_position
