extends State

@onready var Hitbox = preload("res://Weppons/hitbox.tscn")

@export var Falling: State
@export var Jump: State
@export var Dash: State

var can_Cancel: bool
var will_return: bool
var hit_instance1
var hit_instance2
var is_insstantiated: bool

func enter():
	is_insstantiated = false
	character_RigidBody.can_guard = false
	character_RigidBody.can_switch = false
	character_RigidBody.can_move = false
	animation_player.play(animation_name)
	hit_instance1 = Hitbox.instantiate()
	hit_instance2 = Hitbox.instantiate()

func startup():
	can_Cancel = false
	character_RigidBody.can_move = false
	character_RigidBody.linear_velocity = Vector3(0,0,0)

func active():
	can_Cancel = true
	character_RigidBody.apply_impulse(Vector3(0, 1500, 0))
	add_child(hit_instance1)
	hit_instance1.set_shape($"../../../SKUNK_PSX2", 2, Vector3(7,7,2), Vector3(0,3,2))

func rising():
	hit_instance1.queue_free()
	add_child(hit_instance2)
	is_insstantiated = true
	hit_instance2.set_shape($"../../../SKUNK_PSX2", 1, Vector3(3,10,7), Vector3(0,2,2))

func process_input(event: InputEvent) -> State:
	if can_Cancel:
		if Input.is_action_just_pressed("jump"):
			return Jump
		if Input.is_action_just_pressed("dash"):
			return Dash
	return null

func endAttack():
	$"../..".change_state(Falling)

func exit():
	character_RigidBody.can_guard = true
	character_RigidBody.can_switch = true
	character_RigidBody.can_move = true
	if is_insstantiated:
		hit_instance2.queue_free()
