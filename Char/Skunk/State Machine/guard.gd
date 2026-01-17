extends State

@export var Hold: State

func next():
	$"..".change_state(Hold)
