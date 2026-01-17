extends State2

@export var Fall: State2

func enter() -> void:
	parent.apply_impulse(Vector3(0, 1500, 0))
	jump()
	await get_tree().create_timer(0.3).timeout
	state_Machine.change_state(Fall)


func jump():
	var enemypos : RayCast3D = $"../../SKUNK_PSX2/metarig/Skeleton3D/wallcheck1"
	var forward : Vector3 = -0.5 * (enemypos.to_global(enemypos.target_position) - enemypos.global_position)
	parent.apply_impulse((forward * parent.dash_speed) * 2)
	parent.theta = wrapf(atan2(forward.x, forward.z) - parent.rig.rotation.y, -PI, PI)
	parent.rig.rotation.y += clamp(parent.rotation_speed, 0, abs(parent.theta) * sign(parent.theta))
