extends State

@export var Hold: State

func NextState():
	$"../../..".change_state(Hold)
