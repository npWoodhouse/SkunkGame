extends Node

@export var Face : MeshInstance3D
@onready var Eyes = Face.get_surface_override_material(2)
@onready var Mouth = Face.get_surface_override_material(1)

var blink_timer : float = 0.0
var can_blink : bool

#functions for blinking if its alowed by the face preset
func _process(delta: float) -> void:
	if can_blink:
		blink_timer += 0.1
		if blink_timer > 20:
			blink()
			blink_timer = 0

func blink():
	can_blink = true
	Eyes.uv1_offset.x = 0.5
	await get_tree().create_timer(0.1).timeout
	Eyes.uv1_offset.x = 0

#face presets
func neutral():
	can_blink = true
	Eyes.uv1_offset.x = 0
	Eyes.uv1_offset.y = 0.25
	Mouth.uv1_offset.y = 0.0
	Mouth.uv1_offset.x = 0

func angry():
	can_blink = false
	Eyes.uv1_offset.x = 0
	Eyes.uv1_offset.y = 0.5
	Mouth.uv1_offset.y = 0.5
	Mouth.uv1_offset.x = 0

func smug():
	can_blink = true
	Eyes.uv1_offset.x = 0
	Eyes.uv1_offset.y = 0.5
	Mouth.uv1_offset.y = 0.25
	Mouth.uv1_offset.x = 0

func frightened():
	can_blink = false
	Eyes.uv1_offset.x = 0
	Eyes.uv1_offset.y = 0.75
	Mouth.uv1_offset.y = 0
	Mouth.uv1_offset.x = 0.5

func oof():
	can_blink = false
	Eyes.uv1_offset.y = 0.5
	Eyes.uv1_offset.x = 0.5
	Mouth.uv1_offset.y = 0.75
	Mouth.uv1_offset.x = 0
	await get_tree().create_timer(0.2).timeout
	Eyes.uv1_offset.y = 0.5
	Eyes.uv1_offset.x = 0
	Mouth.uv1_offset.y = 0.5
	Mouth.uv1_offset.x = 0.5

func pain():
	can_blink = false
	Eyes.uv1_offset.x = 0.5
	Eyes.uv1_offset.y = 0.5
	Mouth.uv1_offset.y = 0.5
	Mouth.uv1_offset.x = 0
