extends Node3D

@export var CellsToColapse : Array[int]
@export var PresetTile : Tile3D

@export var width := 5
@export var depth := 5
@export var height := 2

@onready var cell_scene = preload("res://WaveFunctionTwo/cell.tscn")

@export var Tile_data   : Array[Tile3D]
var cells : Array[Node3D] = []

func _ready():
	randomize()
	create_grid()
	assign_neighbors()
	colapse_preset()
	run_wfc()

func create_grid():
	for y in range(height):
		for z in range(depth):
			for x in range(width):
				var cell = cell_scene.instantiate()
				cell.position = Vector3(x, y, z) * 1.2
				cell.create_cell(Tile_data)
				add_child(cell)
				cells.append(cell)

func assign_neighbors():
	for y in range(height):
		for z in range(depth):
			for x in range(width):
				var i = x + z * width + y * width * depth
				var c = cells[i]

				if x > 0: c.wNeighbor = cells[i - 1]
				if x < width - 1: c.eNeighbor = cells[i + 1]
				if z > 0: c.sNeighbor = cells[i - width]
				if z < depth - 1: c.nNeighbor = cells[i + width]
				if y > 0: c.dNeighbor = cells[i - width * depth]
				if y < height - 1: c.uNeighbor = cells[i + width * depth]

func colapse_preset():
	if CellsToColapse:
		for ints in CellsToColapse:
			cells[ints].options.clear()
			cells[ints].options.append(PresetTile)

func run_wfc():
	while true:
		var candidates = cells.filter(func(c):
			return !c.collapsed and c.entropy() > 0
		)

		if candidates.is_empty():
			break

		candidates.sort_custom(func(a, b):
			return a.entropy() < b.entropy()
		)

		var min_entropy = candidates[0].entropy()
		var lowest = candidates.filter(func(c):
			return c.entropy() == min_entropy
		)

		var cell = lowest.pick_random()
		cell.collapse()  # no parameters
		propagate(cell)

func propagate(start):
	var stack = [start]

	while stack.size() > 0:
		var cell = stack.pop_back()

		var changed := false

		if cell.nNeighbor and cell.nNeighbor.reduce_options_from_neighbor(cell, "s"):
			changed = true
		if cell.sNeighbor and cell.sNeighbor.reduce_options_from_neighbor(cell, "n"):
			changed = true
		if cell.eNeighbor and cell.eNeighbor.reduce_options_from_neighbor(cell, "w"):
			changed = true
		if cell.wNeighbor and cell.wNeighbor.reduce_options_from_neighbor(cell, "e"):
			changed = true
		if cell.uNeighbor and cell.uNeighbor.reduce_options_from_neighbor(cell, "d"):
			changed = true
		if cell.dNeighbor and cell.dNeighbor.reduce_options_from_neighbor(cell, "u"):
			changed = true

		if changed:
			if cell.nNeighbor: stack.append(cell.nNeighbor)
			if cell.sNeighbor: stack.append(cell.sNeighbor)
			if cell.eNeighbor: stack.append(cell.eNeighbor)
			if cell.wNeighbor: stack.append(cell.wNeighbor)
			if cell.uNeighbor: stack.append(cell.uNeighbor)
			if cell.dNeighbor: stack.append(cell.dNeighbor)
