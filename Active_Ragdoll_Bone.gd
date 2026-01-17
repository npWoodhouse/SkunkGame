class_name Active_Ragdoll_Bone
extends RigidBody3D

@export var Boneconnection : BoneAttachment3D

var is_active : bool = true

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_active:
		self.linear_velocity = Vector3(0,0,0)
		self.angular_velocity = Vector3(0,0,0)
		var target_pos : Vector3 = Boneconnection.global_position
		var target_rot: Vector3 = Boneconnection.global_rotation
		
		var pos_dif : Vector3 = target_pos - self.global_position
		var rot_dif : Vector3 = target_rot - self.global_rotation
		
		self.global_position += pos_dif
		self.global_rotation += rot_dif
