extends State2

@export var Hold: State2
@onready var hurtbox = $"../../SKUNK_PSX3"

var pivot : bool = true

func state_process(delta):
	_Move(delta)

func squat():
	pivot = true

func slide():
	pivot = false
	parent.is_intangible = true
	
	hurtbox.shape.height = 2
	hurtbox.position.y = -1
	
	$"../..".set_collision_mask_value(2, false)
	
	var arrow = $"../../SKUNK_PSX2/Forward"
	var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
	var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
	parent.apply_impulse(forward * parent.dash_speed*2)

func end_slide():
	state_Machine.change_state(Hold)

func exit():
	hurtbox.shape.height = 4
	hurtbox.position.y = 0
	$"../..".set_collision_mask_value(2, true)
	parent.is_intangible = false

func _Move(delta):
	if pivot:
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
