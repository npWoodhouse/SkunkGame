extends State

@onready var Hitbox = preload("res://Weppons/hitbox.tscn")

@onready var Parent = $"../../.."
@onready var State_Machine = $"../.."
@onready var Body = $"../../../SKUNK_PSX2"

@export var Sword_hold: State
@export var Sword_L3: State
@export var Sword_R1: State
@export var Harpoon: State
@export var YouToMe: State

var can_Cancel: bool
var will_return: bool

func enter() -> void:
	will_return = true
	var hit_instance = Hitbox.instantiate()
	add_child(hit_instance)
	hit_instance.set_shape(Body, 0.05, 8, 3, Vector3(0,2,2), 5)
	
	can_Cancel = true
	$"../../../Timer".start(1)
	await $"../../../Timer".timeout
	can_Cancel = false
	if will_return:
		State_Machine.change_state(Sword_hold)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("attack.L") and can_Cancel == true:
		if State_Machine.WeponStance == 0:
			return Sword_L3
		if State_Machine.WeponStance == -1:
			return Harpoon
	if Input.is_action_just_pressed("attack.R") and can_Cancel == true:
		if State_Machine.WeponStance == 0:
			return Sword_R1
		if State_Machine.WeponStance == -1:
			return YouToMe
	return null

func exit():
	will_return = false
