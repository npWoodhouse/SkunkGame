extends Enemy_State

@export var ragdoll : Node
var phys_bones : Array

func enter():
	for obj in ragdoll.get_children():
		for child in obj.get_children():
			if child is RigidBody3D:
				phys_bones.append(child)
	
	stop_active()
	disableEnemy()
	animation_player.play(animation_name)

func stop_active():
	for bones in phys_bones:
		if bones is Active_Ragdoll_Bone:
			bones.is_active = false
			#bones.linear_velocity = Vector3(0,0,0)
			#bones.angular_velocity = Vector3(0,0,0)
			bones.gravity_scale = 0.5
			bones.mass = 10

func disableEnemy():
	$"../..".set_collision_layer_value(2, false)
	await get_tree().create_timer(5).timeout
	$"../..".queue_free()
