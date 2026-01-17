extends State

@export var fall: State

func enter():
	animation_player.play(animation_name)
	character_RigidBody.is_intangible = true
	character_RigidBody.can_move = false
	character_RigidBody.can_switch = false
	character_RigidBody.is_falling = false

func next():
	$"..".change_state(fall)
