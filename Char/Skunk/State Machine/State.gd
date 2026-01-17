class_name State
extends Node

@export
var character_RigidBody: RigidBody3D
@export
var animation_name: String
@export
var animation_player: AnimationPlayer

var parent: Player

func enter() -> void:
	animation_player.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null
