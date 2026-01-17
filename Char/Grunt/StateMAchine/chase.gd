extends Enemy_State

@export var Attack: Enemy_State
@export var Idle: Enemy_State
@export var Fireball: Enemy_State
@export var ded: Enemy_State

@export var Personal_space : Area3D

func enter():
	#$"../../PlayerPosDebug".visible = true
	#$"../../PathDebug".visible = true
	parent.ALERT = true
	animation_player.play(animation_name)

func state_process(delta):
	if parent.HP <= 0:
		state_Machine.change_state(ded)
	move_check(delta)
	
	$"../../PathDebug".global_position = parent.Target_POS
	$"../../PlayerPosDebug".global_position = parent.the_player.global_position


func move_check(delta):
	#print_debug($"../../Intrest".time_left)
	if $"../../Intrest".time_left <= 0:
		state_Machine.change_state(Idle)
	
	var target_distance : float = Vector2(parent.global_position.x,parent.global_position.z).distance_to(Vector2(parent.Target_POS.x,parent.Target_POS.z))
	#print_debug(target_distance)
	if parent.hasLOS:
		$"../../Intrest".start(3)
		if target_distance >= 25:
			state_Machine.change_state(Fireball)
		if target_distance > 5 and target_distance < 25:
			_Move(delta)
		elif target_distance < 5:
			state_Machine.change_state(Attack)
		else:
			pass
	if !parent.hasLOS:
		if target_distance > 1:
			_Move(delta)
		elif target_distance < 1:
			state_Machine.change_state(Idle)
		else:
			pass

func _Move(delta):
	var direction := (parent.Target_POS - parent.global_position).normalized()
	direction = direction.rotated(Vector3.UP, parent.rotation.y) * parent.MoveForce
	if absf(parent.linear_velocity.x) < parent.Max_speed and absf(parent.linear_velocity.z) < parent.Max_speed:
		parent.apply_impulse(direction * 3)
	
	if direction:
		parent.theta = wrapf(atan2(direction.x, direction.z) - parent.rig.rotation.y, -PI, PI)
		parent.rig.rotation.y += clamp(parent.rotation_speed * delta, 0, abs(parent.theta) * sign(parent.theta))
	else:
		pass
