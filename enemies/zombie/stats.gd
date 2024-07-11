extends Node

@export var attributes: CharacterAttributes

@onready var weapon = %Weapon
@onready var weapon_damage: Damage = %Weapon.damage
@onready var weapon_adds: ItemAdds = %Weapon.adds

func _ready():
	pass
#	recalculate_attributes()
#	recalculate_items_atributes()

func recalculate_attributes() -> void: # Atributos que serão exibidos na interface de atributos(Tecla 'C')
	
	attributes.HP = weapon_adds.hp + (attributes.constitution+weapon_adds.CONS)*20
	attributes.MP = weapon_adds.mp + (attributes.intelligence+weapon_adds.INT)*24
	attributes.critical_chance = weapon_adds.critical_chance + (attributes.dexterity+weapon_adds.DEX)*1.3
	attributes.critical_damage = weapon_adds.critical_damage + (attributes.strenght+weapon_adds.STR)*3
	attributes.evasion_chance = (attributes.dexterity+weapon_adds.DEX)*1.3
	attributes.speed_of_attack = (0.6 + (attributes.dexterity+weapon_adds.DEX)*0.1) if  (0.6 + (attributes.dexterity+weapon_adds.DEX)*0.1) <= 6 else 6
	
	attributes.damage_base = (weapon_adds.STR+attributes.strenght)*2

