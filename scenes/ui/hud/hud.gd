extends Control

@onready var experience_bar: TextureProgressBar = %ExperienceBar
@onready var current_level: Label = %CurrentLevel
@onready var next_level: Label = %NextLevel


func update_level_indicator(new_current_level: int, new_next_level: int):
	current_level.text = str(new_current_level)
	print("New_current_level: "+str(new_current_level))
	next_level.text = str(new_next_level)
	print("Next_current_level: "+str(new_current_level))
	
	
func update_experience_bar(new_min_value: int, new_max_value: int):
	experience_bar.min_value = new_min_value
	experience_bar.max_value = new_max_value
	reset_experience_bar()

func reset_experience_bar():
	experience_bar.value = 0
