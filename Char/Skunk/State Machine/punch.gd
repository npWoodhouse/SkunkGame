extends State

var charging: bool
var level: int 
var charge : float

@export var Level1: State
@export var Level2: State

func enter():
	charging = true
	animation_player.play(animation_name)
	level = 1
	charge = 0
	character_RigidBody.can_guard = false
	character_RigidBody.can_move = false

func process_input(event: InputEvent) -> State:
	if character_RigidBody.WeponStance == 1:
		if Input.is_action_just_released("attack.L"):
			charging = false
			nextState()
			return null
	return null

func _process(delta):
	if charging:
		charge += 1

func Charge():
	level = 2

func nextState():
	if level < 2:
		$"..".change_state(Level1)
	if level >= 2:
		$"..".change_state(Level2)
