extends Node3D

@export var Head: RigidBody3D
@export var base : StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var direction = self.global_position - Head.global_position
	
	Head.look_at(base.position)
	
	if abs(direction) > Vector3(0.8, 0.8, 0.8):
		Head.linear_velocity = Vector3(0,0,0)
		Head.apply_impulse(direction)
	
	#Head.linear_velocity = Vector3(0,0,0)
	#Head.angular_velocity = Vector3(0,0,0)
