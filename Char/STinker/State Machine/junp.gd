extends State2

@export var Fall: State2
@export var Jump: State2
@export var Dash: State2

func enter() -> void:
	if parent.air_moves > 0:
		animation_player.play(animation_name)
		parent.air_moves -= 1
		parent.linear_velocity = Vector3(0,0,0)
	else:
		endJump()

func state_process(delta):
	_Move(delta)

func jump():
	parent.apply_impulse(Vector3(0, 1500, 0))

func endJump():
	state_Machine.change_state(Fall)

func _Move(delta):
	#taking the players input and setting it as an impulse relitive to the camera pivot
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, parent.spring_arm_pivot.rotation.y) * parent.MoveForce
	#force = direction
	if absf(parent.linear_velocity.x) < parent.Max_speed and absf(parent.linear_velocity.z) < parent.Max_speed:
		parent.apply_impulse(direction * 3)

	if direction:
		parent.theta = wrapf(atan2(direction.x, direction.z) - parent.rig.rotation.y, -PI, PI)
		parent.rig.rotation.y += clamp(parent.rotation_speed * delta, 0, abs(parent.theta) * sign(parent.theta))
