extends State

@export var Hold: State

func enter():
	animation_player.play(animation_name)
	character_RigidBody.is_intangible = true

func next():
	$"..".change_state(Hold)

func exit():
	character_RigidBody.is_intangible = false
