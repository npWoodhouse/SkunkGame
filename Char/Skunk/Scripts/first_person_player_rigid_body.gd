class_name Player2
extends RigidBody3D

#settings 
@onready var max_air_moves: int = 1
@export var MoveForce : float = 10
@onready var rotation_speed : float = 25
@onready var Max_speed : float = 20
@onready var dash_speed : float = 1000

var _theta : float
var air_moves: int = 0
var is_moving : bool
var is_falling : bool
var is_grounded : bool
var Wepon_L : bool
var Wepon_R : bool
var WeponStance : int = -1
var anchor_placed : bool
var force : Vector3
var target : Vector3
var direction : Vector3
var rest_length : float
var collision : RigidBody3D

var is_punching : bool
var is_Stalled : bool = false

var can_move : bool = true
var can_switch : bool = true

#hit variables
var can_guard: bool = true
var is_intangible: bool

var current_HP: int
var max_HP: int = 5

var current_poise: float
var max_poise: float = 100.0


#object refferences camera
@export var _rig: Node3D
@export var GroundCheck: RayCast3D
@export var spring_arm_pivot: Node3D
@export var spring_arm: SpringArm3D

@export var rope: Node3D

@onready var state_machine = $State_machine
@onready var ray = $"spring arm pivot/SpringArm3D/LookAt"
@onready var cross_hair = $"spring arm pivot/SpringArm3D/Camera3D/MeshInstance3D"

@export var Sword: MeshInstance3D
@export var Dagger: MeshInstance3D
@export var GauntletL: MeshInstance3D
@export var GauntletR: MeshInstance3D

#@export var Land : State
#@export var Falling : State
@export var Hold : State
@export var Run : State
@export var Guard : State
@export var AirGuard : State
@export var KnockDown : State

#lock the mouse
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state_machine.init(self)
	rope.scale = Vector3(0,0,0)
	
	current_HP = max_HP
	current_poise = max_poise

# closing the game and mouse inputs
func _unhandled_input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)
	
	if Input.is_action_just_pressed("Wepon_L"):
		if can_switch:
			WeponStance -= 1
		#Wepon_L = true
		#Wepon_R = false
	#if Input.is_action_just_released("Wepon_L"):
		#Wepon_L = false
	if Input.is_action_just_pressed("Wepon_R"):
		if can_switch:
			WeponStance += 1
		#Wepon_R = true
		#Wepon_L = false
	#if Input.is_action_just_released("Wepon_R"):
		#Wepon_R = false
	
	if Input.is_action_just_pressed("DEBUG_LightHit"):
		Hit(10, 0, 1)
	if Input.is_action_just_pressed("DEBUG_HeavyHit"):
		Hit(20, 0, 2)
	
	state_machine.process_input(event)

# checking if jump is pressed
func _process(delta):
	
	if is_Stalled:
		linear_velocity = Vector3(0,0,0)
	
	if current_HP <= 0:
		get_tree().quit()
	
	var collision = ray.get_collider()
	
	is_grounded = GroundCheck.is_colliding()
	if is_grounded:
		air_moves = max_air_moves
	
	#Toggle Wepon stance logic to prevent undefined stances
	if WeponStance > 1:
		WeponStance = -1
	if WeponStance < -1:
		WeponStance = 1
	
	if WeponStance == -1:
		Sword.visible = false
		Dagger.visible = true
		GauntletL.visible = false
		GauntletR.visible = false
	if WeponStance == 0:
		Sword.visible = true
		Dagger.visible = false
		GauntletL.visible = false
		GauntletR.visible = false
	if WeponStance == 1:
		Sword.visible = false
		Dagger.visible = false
		GauntletL.visible = true
		GauntletR.visible = true
	
	#changing the crosshair size
	if WeponStance == -1:
		if ray.is_colliding():
			if !collision.is_in_group("UnHookable"):
				cross_hair.scale = Vector3(0.04, 0.04, 0.04)
			else:
				cross_hair.scale = Vector3(0.02, 0.02, 0.02)
		else:
			cross_hair.scale = Vector3(0.02, 0.02, 0.02)
	else:
		cross_hair.scale = Vector3(0.02, 0.02, 0.02)
	
	_Move(delta)
	
	_Look()
	
	if $State_machine.current_state == Hold and is_moving:
		$State_machine.change_state(Run)
	
	if $State_machine.current_state == Run and !is_moving:
		$State_machine.change_state(Hold)

# movement function
func _Move(delta):
	if can_move:
		#taking the players input and setting it as an impulse relitive to the camera pivot
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y) * MoveForce
		#force = direction
		if absf(self.linear_velocity.x) < Max_speed and absf(self.linear_velocity.z) < Max_speed:
			self.apply_impulse(direction * 3)
	
		if direction:
			is_moving = true
			_theta = wrapf(atan2(direction.x, direction.z) - _rig.rotation.y, -PI, PI)
			_rig.rotation.y += clamp(rotation_speed * delta, 0, abs(_theta) * sign(_theta))
		else:
			is_moving = false

# a function to move the camera with controller inputs
func _Look():
	var look_dir := Input.get_vector("look.L", "look.R", "look.U", "look.D")
	if look_dir:
		spring_arm_pivot.rotate_y(look_dir.x * (2) * -0.01)
		spring_arm.rotate_x(look_dir.y * (2) * -0.01)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)

# this function is the getting hit one
func Hit(poise : float, damage : int, level : int):
	if is_intangible:
		pass
	else:
		if level < 2:
			if can_guard:
				if is_grounded:
					$State_machine.change_state(Guard)
					current_poise -= poise
				else:
					$State_machine.change_state(AirGuard)
					current_poise -= poise
			else:
				$State_machine.change_state(KnockDown)
				current_HP -= damage
				$Customize.woundSkunk()
		if level > 1:
			$State_machine.change_state(KnockDown)
			current_HP -= damage
			$Customize.woundSkunk()
