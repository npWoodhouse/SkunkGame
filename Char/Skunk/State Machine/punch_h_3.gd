extends State

@export var Next: State
var is_Stalled = false

func enter() -> void:
	is_Stalled = true
	character_RigidBody.linear_velocity = Vector3(0,0,0)
	animation_player.play(animation_name)

func exit():
	character_RigidBody.can_guard = true
	character_RigidBody.is_intangible = false
	is_Stalled = false

func dash():
	character_RigidBody.is_intangible = true
	is_Stalled = false
	var arrow = $"../../../SKUNK_PSX2/Forward"
	var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
	var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
	character_RigidBody.apply_impulse(forward * 500)

func _process(delta):
	if is_Stalled:
		character_RigidBody.linear_velocity = Vector3(0,0,0) 

func next():
	$"../..".change_state(Next)
