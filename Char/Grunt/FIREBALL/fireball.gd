extends CharacterBody3D

const SPEED = 30.0
var velo = Vector3()
@onready var Life = $Timer

func _ready() -> void:
	$AnimatedSprite3D.play("default")
	await Life.timeout
	explode()

func _physics_process(delta: float) -> void:
	hitbox()
	
	velo = transform.basis * Vector3(0, 0, SPEED)
	velocity.x = velo.x
	velocity.y = velo.y
	velocity.z = velo.z
	move_and_slide()

func hitbox():
	for bodies in $Area3D.get_overlapping_bodies():
		if bodies.is_in_group("Players"):
			bodies.Hit(30, 1, 1)
			explode()
		if bodies is RigidBody3D or StaticBody3D:
			explode()

func explode():
	self.queue_free()
