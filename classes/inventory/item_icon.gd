extends TextureRect

var tooltip_item_packed_scene: PackedScene
var tooltip_item: Control

@export var item: Item #: 
	#set(value):
		#if value.is_stackable:
		#	%QuantityLabel.visible = true
		#	%QuantityLabel.text = str(value.quantity)
		#else:
		#	%QuantityLabel.visible = false
		#
		#texture = value.icon
var origin_slot: String = "Inventory"

func _ready():
	
	tooltip_item_packed_scene = preload("res://scenes/ui/tooltip/item_tooltip.tscn")
	
	if item != null:
		if item.is_stackable:
			%QuantityLabel.visible = true
			%QuantityLabel.text = str(item.quantity)
		else:
			%QuantityLabel.visible = false
			
		texture = item.icon


func _get_drag_data(at_position): # Dado que será retornado quando clicar duas vezes e arrastar. NÃO é o dado visual, é o dado real que será ARMAZENADO na área de DROP
	if texture != null:
		Mouse.is_dragging = true
		set_drag_preview(get_preview()) # set_drag_preview adiciona o item gerado como filho do nó Control que esteja mais no topo, ou seja, o nó Control mais elevado, que está acima de todos
		return self # Esse vai ser o data
	
	
func get_preview(): # preview é apenas algo VISUAL, ele define o que será VISTO quando o item estiver sendo arrastado
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
	preview_texture.position = Vector2(-15,-15)
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	
	return preview


func generate_tooltip():
	if item is Armor or item is Weapon or item is Shield or item is Ring:
		var title_text = item.item_name
		if item.refining > 0:
			title_text += " [+"+str(item.refining)+"]"
			
		tooltip_item.get_node("%TitleLabel").text = title_text
		
		
		var damage_defense_text = ""
		if item is Weapon:
			damage_defense_text =  "Damage: "+str(item.base_physical_damage_min)+" - "+str(item.base_physical_damage_max)
			if item.refining > 0:
				damage_defense_text += " ["+str(item.physical_damage_min)+" - "+str(item.physical_damage_max)+"]"
		elif item is Armor or item is Shield:
			damage_defense_text = "Defense: "+str(item.base_physical_defense)
			if item.refining > 0:
				damage_defense_text += " ["+str(item.physical_defense)+"]"
			
		tooltip_item.get_node("%DefenseDamageLabel").text = damage_defense_text
			
		var level_requeriment_text = ""
		var str_requeriment_text = ""
		var dex_requeriment_text = ""
		var int_requeriment_text = ""
		
		if item.level_required > 0:
			tooltip_item.get_node("%LevelRequerimentLabel").text = "Level Required: "+str(item.level_required)
			tooltip_item.get_node("%LevelRequerimentLabel").visible = true
		else:
			tooltip_item.get_node("%LevelRequerimentLabel").visible = false
		
		if item.str_required > 0:
			tooltip_item.get_node("%StrRequerimentLabel").text = "Strength Required: "+str(item.str_required)
			tooltip_item.get_node("%StrRequerimentLabel").visible = true
		else:
			tooltip_item.get_node("%StrRequerimentLabel").visible = false
			
		if item.dex_required > 0:
			tooltip_item.get_node("%DexRequerimentLabel").text = "Dexterity Required: "+str(item.dex_required)
			tooltip_item.get_node("%DexRequerimentLabel").visible = true
		else:
			tooltip_item.get_node("%DexRequerimentLabel").visible = false
			
		if item.int_required > 0:
			tooltip_item.get_node("%IntRequerimentLabel").text = "Intelligence Required: "+str(item.int_required)
			tooltip_item.get_node("%IntRequerimentLabel").visible = true
		else:
			tooltip_item.get_node("%IntRequerimentLabel").visible = false
			
		for add in item.adds:
			var add_label: Label = Label.new()
			var add_label_text = ""
			match add.type: ##Type{EMPTY, ATTRIBUTE, COMBAT_PERFORMACE, DAMAGE, DEFENSE, BOOST}
			
				0: #EMPTY
					add_label.label_settings = load("res://settings/empty_add_label_settings.tres")
					add_label_text = "Empty"
				1: #ATTRIBUTE
					add_label.label_settings = load("res://settings/attributes_add_label_settings.tres")
					match add.improvment: #{STR, INT, CONS, DEX, HP, MP}
						0:
							add_label_text = "[+] %s Strength [+]"
						1:
							add_label_text = "[+] %s Intelligence [+]"
						2:
							add_label_text = "[+] %s Constitution [+]"
						3:
							add_label_text = "[+] %s Dexterity [+]"
						4:
							add_label.label_settings = load("res://settings/hp_mp_add_label_settings.tres")
							add_label_text = "[+] %s HP [+]"
						5:
							add_label.label_settings = load("res://settings/hp_mp_add_label_settings.tres")
							add_label_text = "[+] %s MP [+]"
				2: #COMBAT_PERFORMACE
					add_label.label_settings = load("res://settings/stats_add_label_settings.tres")
					match add.improvment: # {CRITICAL_CHANCE, BLOCKING_CHANCE, CRITICAL_DAMAGE, ATTACK_SPEED, EVASION}
						0:
							add_label_text = "[+] %.02s%% Critical Chance [+]"
						1:
							add_label_text = "[+] %.02s%% Blocking Chance [+]"
						2:
							add_label_text = "[+] %.02s%% Critical Damage [+]"
						3:
							add_label_text = "[+] %.02s%% Attack Speed [+]"
						4:
							add_label_text = "[+] %.02s Evasion [+]"
				3: #DAMAGE
					add_label.label_settings = load("res://settings/defense_damage_add_label_settings.tres")
					match add.improvment: # {EXTRA, FIRE, COLD, LIGHTNING, DARKNESS}
						0:
							add_label_text = "[+] %s Extra Damage [+]"
						1:
							add_label_text = "[+] %s Fire Damage [+]"
						2:
							add_label_text = "[+] %s Cold Damage [+]"
						3:
							add_label_text = "[+] %s Lightning Damage [+]"
						4:
							add_label_text = "[+] %s Darkness Damage [+]"
							
				4: #DEFENSE
					add_label.label_settings =  load("res://settings/defense_damage_add_label_settings.tres")
					match add.improvment:
						0:
							add_label_text = "[+] %s Extra Defense [+]"
						1:
							add_label_text = "[+] %s Fire Defense [+]"
						2:
							add_label_text = "[+] %s Cold Defense [+]"
						3:
							add_label_text = "[+] %s Lightning Defense [+]"
						4:
							add_label_text = "[+] %s Darkness Defense [+]"
							
				5: #BOOST
					add_label.label_settings = load("res://settings/boost_add_label_settings.tres")
					match add.improvment: # {XP, ESSENCE, GOLD}
						0:
							add_label_text = "[+] x%s XP BOOST [+]"
						1:
							add_label_text = "[+] x%s ESSENCE BOOST [+]"
						2:
							add_label_text = "[+] x%s GOLD BOOST [+]"
						
			add_label.text = add_label_text % str(add.value) if add.type != 0 else add_label_text
			tooltip_item.get_node("%AdditionalsContainer").add_child(add_label)
		
		
		var quality_text = ""
		match item.quality: # { COMMON = 1, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
			1:
				quality_text = "Common"
			2:
				quality_text = "Special"
			3:
				quality_text = "Very Special"
			4:
				quality_text = "Epic"
			7:
				quality_text = "Celestial"
		tooltip_item.get_node("%RarityLabel").text = quality_text
	
	
func _on_mouse_entered():
	if item != null:
		for child in get_parent().get_children():
			if child.name.begins_with("ToolTip"):
				get_parent().remove_child(child)

	#	tooltip_item = tooltip_item_packed_scene.instantiate()
	#	TooltipManager.generate_tooltip(item)
		tooltip_item = TooltipManager.generate_tooltip(item)
		$Timer.start(0.5)

func _on_mouse_exited():
	for child in get_parent().get_children():
		if child.name.begins_with("ToolTip"):
			get_parent().remove_child(child)
	$Timer.stop()
	
func _on_timer_timeout():
	if item != null:
		get_parent().add_child(tooltip_item)


