extends State

@export 
var State_Machine: Node

@export
var PlayerRB: RigidBody3D

@export
var Jump: State

@export
var Idle: State

@export var rope: Node3D

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_released("attack.L"):
		return Idle
	if Input.is_action_just_pressed("jump"):
		return Jump
	return null

func _physics_process(delta: float) -> void:
	anchored()
	make_rope()

func anchored():
	if character_RigidBody.anchor_placed:
		var direction = character_RigidBody.target - PlayerRB.position
		if PlayerRB.position.distance_to(character_RigidBody.target) > character_RigidBody.rest_length:
			PlayerRB.apply_impulse(direction * (1 * PlayerRB.position.distance_to(character_RigidBody.target)))

func make_rope():
	if character_RigidBody.anchor_placed == true:
		character_RigidBody.is_falling = false
		rope.look_at(character_RigidBody.target)
		var dist = rope.global_position.distance_to(character_RigidBody.target)
		rope.scale = Vector3(1, 1, (dist))

func exit() -> void:
	character_RigidBody.is_falling = true
	character_RigidBody.anchor_placed = false
	rope.scale = Vector3(0, 0, 0)
