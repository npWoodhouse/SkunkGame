extends State2


var charging: bool
var level: int 
var charge : float

@export var Level1: State2
@export var Level2: State2
@export var Level3: State2


func enter():
	charging = true
	animation_player.play(animation_name)
	charge = 0

func state_process(delta):
	if Input.is_action_just_released("attack.L"):
			charging = false
			nextState()
	if charging:
		charge += 1
 
func nextState():
	if charge < 30:
		state_Machine.change_state(Level1)
	if charge >= 30 and charge < 60:
		state_Machine.change_state(Level2)
	if charge >= 60:
		state_Machine.change_state(Level3)
		
