extends State

@export var Hold: State
@export var Fall: State
@export var Jump: State

func enter() -> void:
	if character_RigidBody.air_moves > 0:
		character_RigidBody.can_guard = false
		character_RigidBody.is_Stalled = true
		character_RigidBody.can_move = false
		character_RigidBody.linear_velocity = Vector3(0,0,0)
		animation_player.play(animation_name)
		character_RigidBody.air_moves -= 1
	else:
		next()

func exit():
	character_RigidBody.can_move = true
	character_RigidBody.can_guard = true
	character_RigidBody.is_intangible = false
	character_RigidBody.is_Stalled = false

func dash():
	character_RigidBody.is_intangible = true
	character_RigidBody.is_Stalled = false
	var arrow = $"../../SKUNK_PSX2/Forward"
	var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
	var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
	character_RigidBody.apply_impulse(forward * character_RigidBody.dash_speed)

func next():
	character_RigidBody.is_falling = true
	if character_RigidBody.is_grounded:
		$"..".change_state(Hold)
	if !character_RigidBody.is_grounded:
		$"..".change_state(Fall)
