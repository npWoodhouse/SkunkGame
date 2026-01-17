extends State2

@export var Hold: State2

@onready var HITBOX = preload("res://Weppons/hitbox.tscn")
@onready var hand = $"../../SKUNK_PSX2/metarig/Skeleton3D/hand_R_2/hand_R_2/HitPoint_Punch_L1"
var hit_instance1

func dash():
	if $"../../enemy detection".is_targeting:
		var enemypos : Vector3 = $"../../enemy detection".enemy_pos
		var enemy_vector : Vector3 = (enemypos - parent.global_position).normalized()
		var forward : Vector3 = Vector3(enemy_vector.x,0,enemy_vector.z) 
		parent.apply_impulse((forward * parent.dash_speed) * 2)
		parent.theta = wrapf(atan2(forward.x, forward.z) - parent.rig.rotation.y, -PI, PI)
		parent.rig.rotation.y += clamp(parent.rotation_speed, 0, abs(parent.theta) * sign(parent.theta))
	else:
		var arrow = $"../../SKUNK_PSX2/Forward"
		var arrow_end = arrow.transform * (Vector3.FORWARD)
		var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
		parent.apply_impulse((forward * parent.dash_speed) * -2)

func hitboxON():
	hit_instance1 = HITBOX.instantiate()
	hit_instance1.global_position = hand.global_position
	hit_instance1.set_shape(1, 30, 1, 1)
	add_child(hit_instance1)

func next():
	state_Machine.change_state(Hold)
