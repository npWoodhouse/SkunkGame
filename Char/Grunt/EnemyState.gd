class_name Enemy_State
extends Node

@export
var state_Machine: Node
@export
var animation_name: String
@export
var animation_player: AnimationPlayer

var parent: Enemy

func enter() -> void:
	animation_player.play(animation_name)
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State2:
	return null

func state_process(delta):
	pass
