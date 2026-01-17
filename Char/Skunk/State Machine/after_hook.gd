extends State


@onready var State_Machine = $"../.."

@export var hold: State
@export var Jump: State
@export var Dash: State
@export var Sword_L1: State
@export var Sword_R1: State

var will_return: bool

func enter() -> void:
	will_return = true
	$"../../../Timer".start(0.5)
	await $"../../../Timer".timeout
	if will_return:
		State_Machine.change_state(hold)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return Jump
	if Input.is_action_just_pressed("attack.L"):
		return Sword_L1
	if Input.is_action_just_pressed("attack.R"):
		return Sword_R1
	if Input.is_action_just_pressed("dash"):
		return Dash
	return null

func exit():
	will_return = false
