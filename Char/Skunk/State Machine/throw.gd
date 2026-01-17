extends State

@export var Hold: State
@export var Grab: State
@export var Dash: State
@export var Grabbox : Area3D

var grabbedObjects: Array[RigidBody3D]
var Grabbing : bool

func enter() -> void:
	animation_player.play(animation_name)
	grabbedObjects = Grab.Objects
	grabbedObjects += Dash.Objects
	Grab.Objects.clear()
	Dash.Objects.clear()
	Grabbing = true

func NextState():
	$"../../..".change_state(Hold)

func _process(delta: float) -> void:
	if Grabbing:
		for object in grabbedObjects:
			object.global_position = Grabbox.global_position 

func Release():
	Grabbing = false
	for object in grabbedObjects:
		var arrow = $"../../../../SKUNK_PSX2/Forward"
		var arrow_end = arrow.transform * (Vector3.FORWARD * -1)
		var Direction = arrow.to_global(arrow_end + Vector3(0,1,0)) - arrow.global_transform.origin 
		object.apply_impulse(Direction * 800)
	grabbedObjects.clear()
