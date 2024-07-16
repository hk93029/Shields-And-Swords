extends Character

@export var death_experience_min: int = 30 #Enemy
@export var death_experience_max: int = 40 #Enemy

var damage_base: int
var blocking_chance: int = 30

func _ready():
	add_to_group("character", true)
	hp_bar.max_value = max_health
	hp_bar.value = max_health
	
	print(str(hp_bar.max_value))
	
	char_stats = CharacterStatus.new()
	equips_adds = EquipmentsAdditionals.new()

	if armor != null:
		equip_item(armor)
#		armor_adds = armor.adds
	if ring != null:
		equip_item(ring)
		#ring_adds = ring.adds
	if amulet != null:
		equip_item(amulet)
		#amulet_adds = amulet.adds
	if weapon != null:
		equip_item(weapon)
		#weapon_adds = weapon.adds

	

	damage_digit_prefab = preload("res://misc/damage_digit/damage_digit.tscn")
	critical_damage_digit_prefab = preload("res://misc/damage_digit/critical_damage_digit.tscn")
	blocked_damage_digit_prefab = preload("res://misc/damage_digit/blocked_damage_digit.tscn")
	evaded_damage_digit_prefab =  preload("res://misc/damage_digit/evaded_damage_digit.tscn")

	recalculate_status()

func play_damage_effect():
	#print(health)
	pass

func play_death_effect():
	print("Morto!")
	queue_free()

func _die():
	get_tree().call_group("player_stats", "update_exp", randi_range(death_experience_min, death_experience_max))
	queue_free()
	print("XD")
			
func _on_clickable_area_2d_mouse_entered():
	Mouse.change_state(self)


func _on_clickable_area_2d_mouse_exited():
	if Mouse.target_body == self:
		Mouse.reset()
