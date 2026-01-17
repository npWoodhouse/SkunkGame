extends State

@onready var Hitbox = preload("res://Weppons/hitbox.tscn")

@onready var Parent = $"../../../.."
@onready var Body = $"../../../../SKUNK_PSX2/metarig"

@export var Hold: State

func NextState():
	$"../../..".change_state(Hold)

func exit():
	character_RigidBody.can_guard = true
	character_RigidBody.can_switch = true
	character_RigidBody.can_move = true
	character_RigidBody.is_grounded = true
