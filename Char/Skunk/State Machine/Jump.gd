extends State

@export var Land: State
@export var Fall: State
@export var Jump: State
@export var Dash: State
@export var State_Machine: Node

func enter() -> void:
	if character_RigidBody.air_moves > 0:
		animation_player.play(animation_name)
		character_RigidBody.air_moves -= 1
		character_RigidBody.linear_velocity = Vector3(0,0,0)
	else:
		endJump()

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return Jump
	if Input.is_action_just_pressed("dash"):
		return Dash
	return null

func jump():
	character_RigidBody.apply_impulse(Vector3(0, 1500, 0))

func endJump():
	character_RigidBody.is_falling = true
	if character_RigidBody.is_grounded:
		State_Machine.change_state(Land)
	if !character_RigidBody.is_grounded:
		State_Machine.change_state(Fall)
