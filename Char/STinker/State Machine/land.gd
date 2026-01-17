extends State2

@export var Hold: State2

func end():
	state_Machine.change_state(Hold)
