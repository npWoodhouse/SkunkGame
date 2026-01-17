extends State

@onready var Hitbox = preload("res://Weppons/hitbox.tscn")

@onready var Parent = $"../../.."
@onready var Body = $"../../../CollisionShape3D/SKUNK_PSX2"

@export var Fall: State

func enter():
	character_RigidBody.can_guard = false
	character_RigidBody.can_switch = false
	character_RigidBody.can_move = false
	animation_player.play(animation_name)

func NextState():
	character_RigidBody.is_falling = false
	$"../..".change_state(Fall)
