class_name Enemy
extends RigidBody3D

@export var state_machine : Node
@export var rig: Node3D
#@export var Sight_cone : Area3D
@export var Personal_space : Area3D
@export var LOS : RayCast3D

#Stat variables
var MoveForce : float = 4
var Max_speed : float = 10
const rotation_speed : float = 100
var theta : float

#health var
const maxHP : int = 5
var HP : int
const  MaxPoise : float = 0
var Poise : float

var is_intangible : bool = false


#pathfinding variables
var hasLOS : bool = false
var the_player : RigidBody3D
var Target_POS : Vector3

var ALERT : bool = false
var ALERT_LVL : float = 0.0

func _unhandled_input(event):
	if Input.is_action_just_pressed("DEBUG_Wound"):
		HP = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HP = maxHP
	Poise = MaxPoise
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if HP <= 0:
		$StateMachine.change_state($StateMachine/Ded)
	alert_decey()
	#print_debug(ALERT)
	hasLOS = false
	LOS_check()
	if hasLOS:
		Target_POS = the_player.global_position
	#print_debug(hasLOS)

func alert_decey():
	if ALERT_LVL > 0:
		ALERT_LVL -= 0.1
	else:
		ALERT = false

func LOS_check():
	var targetpos
	var incollision : bool = false
	for bodies in Personal_space.get_overlapping_bodies():
		if bodies.is_in_group("Players"):
			targetpos = bodies.global_position 
			incollision = true
		else:
			incollision = false
	
	if incollision:
		LOS.look_at(the_player.global_position, Vector3.UP)
		LOS.force_raycast_update()
		
		if LOS.is_colliding():
			var collider = LOS.get_collider()
			if collider.is_in_group("Players"):
				Target_POS = targetpos
				hasLOS = true
				ALERT_LVL = 100
			else:
				hasLOS = false

func Hit(poise : float, damage : int, level : int):
	if !is_intangible:
		if Poise > 0 and level < 2:
			Poise -= poise
			$"Poise lock out".start(10)
		else:
			HP -= damage
			Poise -= poise
			$"Poise lock out".start(15)

func poise_recharge():
	if $"Poise lock out".time_left <= 0:
		if Poise <= MaxPoise:
			Poise += 0.1
