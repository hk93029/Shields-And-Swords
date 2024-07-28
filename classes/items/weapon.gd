class_name Weapon
extends Item

@export var texture: Texture2D

@export var  base_physical_damage_max: int :
	set(value):
		base_physical_damage_max = value
		physical_damage_max = value
		
@export var base_physical_damage_min: int :
	set(value):
		base_physical_damage_min = value
		physical_damage_min = value


var physical_damage_min: int = base_physical_damage_min
var physical_damage_max: int = base_physical_damage_max

enum QualityType{ COMMON = 1, SPECIAL = 2, VERY_SPECIAL = 3, EPIC = 4, CELESTIAL = 7}
@export var quality: QualityType

var max_possible_adds: int = 0
var level: int = 1

@export_category("Weapon Adds")  
@export var adds: Array[Add] :
		set(values):
			values.resize(quality) # Limita o valor de adicionais possíveis em um item
			for i in values.size():
				if values[i] == null:
					var new_add: Add = Add.new()
#					new_add.type = 0
					values[i] = new_add
			adds = values


@export_category("Weapon Refining")
@export var refining: int : 
	set(value):
		refining = clamp(value, 0, 12)
		physical_damage_min = base_physical_damage_min+refining*2 if refining < 12 else base_physical_damage_min*2
		physical_damage_max = base_physical_damage_max+refining*2 if refining < 12 else base_physical_damage_max*2


func _init():
	item_type = ItemType.WEAPON


func _ready():
	physical_damage_min = base_physical_damage_min
	physical_damage_max = base_physical_damage_max
	set_max_possible_adds(quality)
	init_weapon_adds_slots()
	update_weapon_physical_damge(base_physical_damage_min, base_physical_damage_max)
	print("refining: +["+str(refining)+"]")
	print("damage: "+str(base_physical_damage_min)+"-"+str(base_physical_damage_max)+" ("+str(physical_damage_min)+"-"+str(physical_damage_max)+")")
	

func set_max_possible_adds(max_value):
	max_possible_adds = max_value


func init_weapon_adds_slots():
	for index in max_possible_adds:
		if adds[index] == null:
			adds[index] = Add.new()


func update_weapon_physical_damge(base_physical_damage_min: int, base_physical_damage_max: int):
	physical_damage_min = base_physical_damage_min+refining*2
	physical_damage_max = base_physical_damage_max+refining*2
		
		
func add_new_add_to_weapon(new_add: Add):
	for index in max_possible_adds:
		if adds[index].type == Add.Type.EMPTY:
			adds[index] = new_add
			return
	print("Não foi possível inserir adicional na arma.")
	return	
	
	
func reset_weapon_adds():
	for index in max_possible_adds:
		adds[index] = Add.new()


func refine_weapon() -> bool:
	if refining < 9:
		refining += 1
		
		# AUMENTA ATTRIBUTOS DA ARMA #
		
		return true

	return false


func get_weapon_damage():
	
	var damage: Damage = Damage.new()
	for index in adds.size():
		if adds[index].type == Add.Type.DAMAGE: #ATTRIBUTE, *DAMAGE, BOOST, COMBAT_PERFORMACE
			
			match adds[index].improvment:
				DamageAdd.Improvment.EXTRA:
					damage.extra_damage = adds[index].value
					break;
				DamageAdd.Improvment.FIRE:
					damage.fire_damage = adds[index].value
					break;
				DamageAdd.Improvment.COLD:
					damage.cold_damage = adds[index].value
					break;
				DamageAdd.Improvment.LIGHTNING:
					damage.lightning_damage = adds[index].value
					break;
				DamageAdd.Improvment.DARKNESS:
					damage.darkness_damage = adds[index].value
					break;
	
	print("Min: %s; Max: %s", [base_physical_damage_min, base_physical_damage_max])	
	damage.physical_damage = randi_range(physical_damage_min, physical_damage_max)
	
	return damage

#func add_gem_add_to_weapon(gem: Gem) -> bool:
#	for index in max_possible_adds:
#		if adds[index].type != 0:
#			adds[index] = gem.add_effect #gem has a name a price, an add_effect, rarity_level | rarity_level defines the rarity of drop
#			return

