extends State

@export var Hold: State

func next():
	$"../..".change_state(Hold)

func exit():
	character_RigidBody.is_intangible = false
	character_RigidBody.can_move = true
	character_RigidBody.can_switch = true
