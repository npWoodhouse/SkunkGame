extends State

@export var PlayerRB: RigidBody3D

@export var AfterHook: State

@export var rope: Node3D

var is_Stalled = false
var return_Sword = false

func enter() -> void:
	is_Stalled = true
	var distance = PlayerRB.position.distance_to(character_RigidBody.target)
	await get_tree().create_timer(0.5).timeout
	
	PlayerRB.apply_impulse((character_RigidBody.direction * 19 * distance) + Vector3(0, 100, 0))
	is_Stalled = false
	
	hault()
	return

func _physics_process(delta: float) -> void:
	if is_Stalled == true:
		character_RigidBody.collision.linear_velocity = Vector3(0,0,0)
		PlayerRB.linear_velocity = Vector3(0,0,0)
		character_RigidBody.collision.angular_velocity = Vector3(0,0,0)
		make_rope()

func hault():
	$"../..".change_state(AfterHook)
	await get_tree().create_timer(0.1).timeout
	PlayerRB.linear_velocity = Vector3(0,0,0)

func make_rope():
	if character_RigidBody.anchor_placed == true:
		character_RigidBody.is_falling = false
		rope.look_at(character_RigidBody.target)
		var dist = rope.global_position.distance_to(character_RigidBody.target)
		rope.scale = Vector3(1, 1, (dist))

func exit() -> void:
	character_RigidBody.anchor_placed = false
	rope.scale = Vector3(0, 0, 0)
