extends State

@export var Next: State
@export var Wiff: State
@export var Wall: State
@export var Charge : State
@export var Grabbox : Area3D

var started: bool = false
var Objects: Array[RigidBody3D]
var Gotcha: bool
var collision : bool = false
var is_checking : bool = false
var cyclesLeft : int

func enter() -> void:
	started = true
	cyclesLeft = Charge.maxCycles
	Gotcha = false
	is_checking = true
	collision = false
	animation_player.play(animation_name)
	character_RigidBody.gravity_scale = 0.0

func CheckCollision():
	var collision = $"../../../../SKUNK_PSX2/Forward".get_collider()
	if $"../../../../SKUNK_PSX2/Forward".is_colliding():
		if !collision.is_in_group("Dynamic_Assets"):
			collision = true
			character_RigidBody.linear_velocity = Vector3(0,0,0)
			is_checking = false
			Objects.clear()
			$"../../..".change_state(Wall)

func Cycle():
	cyclesLeft -= 1
	var arrow = $"../../../../SKUNK_PSX2/Forward"
	var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
	var forward = arrow.to_global(arrow_end) - arrow.global_transform.origin 
	character_RigidBody.apply_impulse(forward*500)

func _process(delta):
	if is_checking:
		CheckCollision()
		if !Gotcha:
			for object in Grabbox.get_overlapping_bodies():
				if object.is_in_group("Dynamic_Assets"):
					Gotcha = true
					Objects.append(object)
		for object in Objects:
				object.global_position = Grabbox.global_position
	if cyclesLeft <= 0 and started:
		if Objects.size() > 0:
			$"../../..".change_state(Next)
		else:
			$"../../..".change_state(Wiff)

func exit():
	started = false
	is_checking = false
	#Objects.clear()
	character_RigidBody.gravity_scale = 5.0
	character_RigidBody.linear_velocity = Vector3(0,0,0)
	cyclesLeft = 5
