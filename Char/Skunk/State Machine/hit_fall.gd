extends State

@export var Land: State

var checking : bool

func enter():
	animation_player.play(animation_name)
	checking = true

func _process(delta):
	if character_RigidBody.is_grounded and checking:
		checking = false
		$"../..".change_state(Land)
