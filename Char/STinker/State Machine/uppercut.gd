extends State2

@export var Fall: State2
@export var Charge: State2

func jump():
	parent.apply_impulse(Vector3(0, (Charge.charge*20), 0))

func endJump():
	state_Machine.change_state(Fall)
