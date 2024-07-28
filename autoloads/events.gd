extends Node

signal level_upped(level_attribute_points)
signal attributes_changed(new_attributes)

signal post_current_status(current_character_status)
signal post_current_attributes(current_character_attributes)
signal post_current_level(level)
signal post_equipped_armor(armor)
signal post_equipped_weapon(weapon)
signal post_equipped_shield(shield)
signal post_equipped_ring(ring)
signal post_equipped_amulet(amulet)

signal post_equips_attributes_adds(cons_add, str_add, dex_add, int_add)

signal post_current_essence(essence)
signal post_current_gold(gold)

signal drop_gold(gold)
signal drop_essence(essence)

signal armor_equipped(armor)
signal weapon_equipped(weapon)
signal shield_equipped(shield)
signal ring_equipped(ring)
signal amulet_equipped(amulet)
