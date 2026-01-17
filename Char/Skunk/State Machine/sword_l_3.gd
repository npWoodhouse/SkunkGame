extends State

@onready var Hitbox = preload("res://Weppons/hitbox.tscn")

@onready var Parent = $"../../.."
@onready var State_Machine = $"../.."
@onready var Body = $"../../../CollisionShape3D/SKUNK_PSX2"

@export var Sword_hold: State
@export var Sword_R1: State

var can_Cancel: bool
var will_return: bool

func enter() -> void:
	will_return = true
	var hit_instance = Hitbox.instantiate()
	add_child(hit_instance)
	hit_instance.set_shape(Body, 0.05, 4, 5, Vector3(0,4,6), 10)
	
	can_Cancel = true
	$"../../../Timer".start(1)
	await $"../../../Timer".timeout
	can_Cancel = false
	if will_return:
		State_Machine.change_state(Sword_hold)

func exit():
	will_return = false
