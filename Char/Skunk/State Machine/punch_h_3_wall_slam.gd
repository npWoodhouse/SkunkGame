extends State

@export var Next: State

func next():
	$"../../..".change_state(Next)
