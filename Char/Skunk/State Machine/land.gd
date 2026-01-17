extends State

@export var Hold: State
@onready var State_Machine = $".."


func enter():
	animation_player.play(animation_name)
	$"../../Timer".start(0.3333)
	await $"../../Timer".timeout
	State_Machine.change_state(Hold)
