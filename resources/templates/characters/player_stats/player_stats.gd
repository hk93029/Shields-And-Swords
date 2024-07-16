extends Node

var level: int = 1
var exp_necessary: Array[int] = [0, 100, 530, 970, 1900, 4800, 6500, 9000, 13000, 17800, 25000, 40000, 90000, 200000, 600000, 1300000, 3000000] # para lvl 1 precisa de 100xp para lvl 2 precisa de 130...
var current_exp: int = 0
var level_atribute_points: int = 0
var player: Player

func _ready():
	Events.connect("attributes_changed", on_attributes_changed)
	player = get_parent()
	post_current_status()
	post_current_attributes()


#func _get_target_body():
#	return player.get_target_body()

func level_up(): # player
	
	level += 1
	level_atribute_points += 3
	UI.HUD.update_experience_bar(exp_necessary[level-1], exp_necessary[level])
	UI.HUD.update_level_indicator(level, level+1) # (current_level, next_level)
	Events.emit_signal("level_upped", 3)
	level_atribute_points = 0
	
func update_exp(exp: int) -> void: # player
	
	current_exp += exp
	if (level <= 50 and current_exp >= exp_necessary[level]):
		level_up()
	
	UI.HUD.experience_bar.value = current_exp

func on_attributes_changed(new_attributes):
	player.char_attributes = new_attributes
	player.recalculate_status()

func post_current_status():
	Events.emit_signal("post_current_status", player.char_stats)
	
func post_current_attributes():
	Events.emit_signal("post_current_attributes", player.char_attributes)
