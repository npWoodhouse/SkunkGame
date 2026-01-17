extends State2

@export var Hold: State2
@export var Grab: State2
@export var Grabbox : Area3D

var grabbedObjects: Array[RigidBody3D]

func enter() -> void:
	$"../../enemy detection".grabbing = true
	animation_player.play(animation_name)
	grabbedObjects += Grab.Objects
	Grab.Objects.clear()

func NextState():
	$"../../enemy detection".grabbing = false
	state_Machine.change_state(Hold)

func state_process(delta):
	for object in grabbedObjects:
		object.global_position = Grabbox.global_position 

func throw():
	for object in grabbedObjects:
		object.Hit(50,2,2)
		var arrow = $"../../SKUNK_PSX2/Forward"
		var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
		var Direction = arrow.to_global(arrow_end + Vector3(0,1,0)) - arrow.global_transform.origin 
		object.apply_impulse(Direction * 800)
	grabbedObjects.clear()
