extends State

@export var Hold: State
@export var Punch: State
@export var Dash: State
@export var HeavyPunch: State

var hit_connected : bool

func enter():
	animation_player.play(animation_name)
	character_RigidBody.is_punching = true
	character_RigidBody.can_guard = false
	character_RigidBody.can_move = true
	hit_connected = false

func NextState():
	$"../..".change_state(Hold)

func dash():
	#var arrow = $"../../../SKUNK_PSX2/Forward"
	#var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
	#var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
	#character_RigidBody.apply_impulse(forward * character_RigidBody.dash_speed)
	var target_pos : Vector3 = $"../../../enemy detection".enemy_pos
	var player_pos : Vector3 = Vector3(character_RigidBody.global_position.x, 0, character_RigidBody.global_position.z)
	character_RigidBody.apply_impulse((target_pos - player_pos)*200)
	

func hit():
	character_RigidBody.linear_velocity = Vector3(0,0,0)
	character_RigidBody.can_move = false
	hit_connected = true

func process_input(event: InputEvent) -> State:
	if character_RigidBody.WeponStance == 1:
		if Input.is_action_just_pressed("attack.L") and hit_connected == true:
			return Punch
		if Input.is_action_just_pressed("dash") and hit_connected == true:
			return Dash
	return null

func exit():
	hit_connected = false
	character_RigidBody.is_punching = false
	character_RigidBody.can_move = true
