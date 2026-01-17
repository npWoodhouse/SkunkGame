extends State

@export var Hold : State
@export var Throw : State

@export var Grabbox : Area3D
var Objects: Array[RigidBody3D]
var Gotcha: bool

func enter() -> void:
	animation_player.play(animation_name)
	Gotcha = false

func NextState():
	$"../..".change_state(Hold)

func Grab():
	for object in Grabbox.get_overlapping_bodies():
		if object.is_in_group("Dynamic_Assets"):
			Gotcha = true
			Objects.append(object)

func ThrowCheck():
	if Gotcha:
		$"../..".change_state(Throw)
