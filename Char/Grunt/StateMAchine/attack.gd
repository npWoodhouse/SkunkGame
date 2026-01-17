extends Enemy_State

@export var Idle: Enemy_State

@onready var HITBOX = preload("res://Weppons/Enemyhitbox.tscn")

var can_rotate : bool = true

@onready var hand = $"../../CollisionShape3D/metarig/Skeleton3D/hand01_L/HITPOINT"

var hit_instance1


func state_process(delta):
	if can_rotate:
		var direction := (parent.Target_POS - parent.global_position).normalized()
		direction = direction.rotated(Vector3.UP, parent.rotation.y) * parent.MoveForce
		
		if direction:
			parent.theta = wrapf(atan2(direction.x, direction.z) - parent.rig.rotation.y, -PI, PI)
			parent.rig.rotation.y += clamp(parent.rotation_speed * delta, 0, abs(parent.theta) * sign(parent.theta))
		else:
			pass

func lunge():
	can_rotate = false
	var arrow = $"../../CollisionShape3D/forward"
	var arrow_end = arrow.transform * (Vector3.FORWARD)
	var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
	parent.apply_impulse(forward*-300)

func hitboxON():
	hit_instance1 = HITBOX.instantiate()
	hit_instance1.global_position = hand.global_position
	hit_instance1.set_shape(1, 30, 1, 1)
	add_child(hit_instance1)

#func hitboxOFF():
	#hit_instance1.queue_free()

func next():
	can_rotate = true
	state_Machine.change_state(Idle)
