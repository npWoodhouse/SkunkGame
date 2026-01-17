extends Node3D


var collapsed := false
var options : Array[Tile3D] = []

var uNeighbor : Node3D
var dNeighbor : Node3D
var nNeighbor : Node3D
var sNeighbor : Node3D
var eNeighbor : Node3D
var wNeighbor : Node3D

func create_cell(tile_options : Array[Tile3D]):
	options = tile_options.duplicate()
	collapsed = false

func entropy() -> int:
	return options.size()

func collapse():
	if collapsed:
		return

	var chosen : Tile3D = options.pick_random()

	if chosen.tile_scene == null:
		push_error("Tile3D '" + chosen.id + "' has no tile_scene assigned!")
		return

	var tile_instance = chosen.tile_scene.instantiate()
	tile_instance.global_transform = global_transform
	get_tree().current_scene.add_child.call_deferred(tile_instance)

	options = [chosen]
	collapsed = true

func reduce_options_from_neighbor(neighbor : Node3D, dir : String) -> bool:
	if neighbor == null or neighbor.options.size() == 0:
		return false

	var before := options.size()

	options = options.filter(func(tile):
		for n_tile in neighbor.options:
			if tiles_match(tile, n_tile, dir):
				return true
		return false
	)

	return options.size() < before

func tiles_match(a : Tile3D, b : Tile3D, dir : String) -> bool:
	match dir:
		"u": return a.PosY_neighbor == b.NegY_neighbor
		"d": return a.NegY_neighbor == b.PosY_neighbor
		"n": return a.PosZ_neighbor == b.NegZ_neighbor
		"s": return a.NegZ_neighbor == b.PosZ_neighbor
		"e": return a.PosX_neighbor == b.NegX_neighbor
		"w": return a.NegX_neighbor == b.PosX_neighbor
	return false
