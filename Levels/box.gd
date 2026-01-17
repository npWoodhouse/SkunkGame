extends RigidBody3D

var force = 600

func granade_hit(source):
	apply_central_force((global_transform.origin - source).normalized() * force)
