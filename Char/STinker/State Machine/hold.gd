extends State2

@export var Move: State2
@export var Jump: State2
@export var Fall: State2
@export var punch: State2
@export var Slide: State2

func state_process(delta):
	_Move(delta)
	
	if !parent.is_grounded:
		state_Machine.change_state(Fall)
	
	if Input.is_action_just_pressed("jump"):
		state_Machine.change_state(Jump)
	
	if Input.is_action_just_pressed("attack.L"):
		state_Machine.change_state(punch)
	
	if Input.is_action_just_pressed("dash"):
		state_Machine.change_state(Slide)

func _Move(delta):
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	if input_dir:
		state_Machine.change_state(Move)
