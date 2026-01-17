extends State

@onready var Hitbox = preload("res://Weppons/hitbox.tscn")

@onready var Parent = $"../../../.."
@onready var Body = $"../../../CollisionShape3D/SKUNK_PSX2"

@export var Land: State

var checking : bool

func enter():
	animation_player.play(animation_name)
	checking = true

func _process(delta):
	if character_RigidBody.is_grounded and checking:
		checking = false
		$"../../..".change_state(Land)
