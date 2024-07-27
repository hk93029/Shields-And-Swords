extends TileMap

func is_on_ground(mouse_pos):
	#var mouse_pos = get_global_mouse_position()
	var tile_pos = local_to_map(mouse_pos) # ground wall
	
	var tile_data = get_cell_tile_data(0, tile_pos)
	if tile_data != null:
		if tile_data.terrain == 0:
			return true
	
	return false

