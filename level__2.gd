extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for nodes in get_children():
		if nodes.is_in_group("ENEMY"):
			nodes.the_player = $Player
