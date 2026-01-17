extends State

@export var Level1: State
@export var Level2: State
@export var Level3: State

var Charge : int = 1
var charging : bool
var maxCycles : int

func enter():
	charging = true
	animation_player.play(animation_name)
	Charge = 1
	maxCycles = 5
	character_RigidBody.can_guard = false
	character_RigidBody.can_move = false

func Level_TWO() -> void:
	Charge = 2
	if charging:
		maxCycles = 5

func Level_THREE() -> void:
	Charge = 3
	if charging:
		maxCycles = 10

func NextState():
	if Charge == 1:
		if !charging:
			$"../..".change_state(Level1)
	if Charge == 2:
		if !charging:
			$"../..".change_state(Level2)
	if Charge == 3:
		$"../..".change_state(Level3)

func process_input(event: InputEvent) -> State:
	if character_RigidBody.WeponStance == 1:
		if Input.is_action_just_released("attack.R"):
			charging = false
			return null
	return null
