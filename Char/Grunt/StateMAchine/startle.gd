extends Enemy_State

@export var Idle: Enemy_State


func state_process(delta):
	var direction := (parent.Target_POS - parent.global_position).normalized()
	direction = direction.rotated(Vector3.UP, parent.rotation.y) * parent.MoveForce
	
	if direction:
		parent.theta = wrapf(atan2(direction.x, direction.z) - parent.rig.rotation.y, -PI, PI)
		parent.rig.rotation.y += clamp(parent.rotation_speed * delta, 0, abs(parent.theta) * sign(parent.theta))
	else:
		pass

func Next():
	parent.ALERT = true
	state_Machine.change_state(Idle)
