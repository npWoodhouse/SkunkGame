extends State2

@export var Hold : State2
@export var Throw : State2

@export var Grabbox : Area3D
var Objects: Array[RigidBody3D]
var Gotcha: bool

func enter() -> void:
	animation_player.play(animation_name)
	Gotcha = false

func NextState():
	state_Machine.change_state(Hold)

func dash():
	if $"../../enemy detection".is_targeting:
		var enemypos : Vector3 = $"../../enemy detection".enemy_pos
		var enemy_vector : Vector3 = (enemypos - parent.global_position).normalized()
		var forward : Vector3 = Vector3(enemy_vector.x,0,enemy_vector.z) 
		parent.apply_impulse((forward * parent.dash_speed) * 1)
		parent.theta = wrapf(atan2(forward.x, forward.z) - parent.rig.rotation.y, -PI, PI)
		parent.rig.rotation.y += clamp(parent.rotation_speed, 0, abs(parent.theta) * sign(parent.theta))
	else:
		var arrow = $"../../SKUNK_PSX2/Forward"
		var arrow_end = arrow.transform * (Vector3.FORWARD)
		var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
		parent.apply_impulse((forward * parent.dash_speed) * -1)

func Grab():
	for object in Grabbox.get_overlapping_bodies():
		if object.is_in_group("Grabbable"):
			Gotcha = true
			Objects.append(object)

func ThrowCheck():
	if Gotcha:
		state_Machine.change_state(Throw)
