extends State2

@export var Land: State2
@export var Jump: State2
@export var walljump: State2

func state_process(delta):
	_Move(delta)
	if parent.is_grounded:
		state_Machine.change_state(Land)
	
	if Input.is_action_just_pressed("jump"):
		if parent.can_walljump:
			state_Machine.change_state(walljump)
		else:
			state_Machine.change_state(Jump)

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
