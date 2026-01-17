extends State

@export var Fall: State
@export var Charge: State

func enter() -> void:
	animation_player.play(animation_name)
	character_RigidBody.can_guard = false
	character_RigidBody.can_move = false
	character_RigidBody.linear_velocity = Vector3(0,0,0)


func jump():
	character_RigidBody.can_move = true
	character_RigidBody.apply_impulse(Vector3(0, (Charge.charge*20)+1000, 0))

func endJump():
	$"../..".change_state(Fall)
	character_RigidBody.can_move = true
