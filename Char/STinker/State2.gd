class_name State2
extends Node

@export
var state_Machine: Node
@export
var animation_name: String
@export
var animation_player: AnimationPlayer

var parent: Player

func enter() -> void:
	animation_player.play(animation_name)

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State2:
	return null

func state_process(delta):
	pass
