class_name Player
extends RigidBody3D

#playerstats
const MaxHP : int = 5
var HP : int = 5
const  MaxPoise : float = 100
var Poise : float = 100

var is_intangible : bool = false

#references to other nodes
@export var state_machine : Node
@export var GroundCheck: RayCast3D
@export var spring_arm_pivot: Node3D
@export var spring_arm: SpringArm3D
@export var rig: Node3D

#variables used for moving
const MoveForce : float = 10
const rotation_speed : float = 25
const Max_speed : float = 20
const dash_speed : float = 1000
var theta : float

#ground check variables
const max_air_moves: int = 1
var air_moves: int = 0
var is_grounded : bool

#walljump variables
var can_walljump : bool = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)
	
	if Input.is_action_just_pressed("DEBUG_LightHit"):
		Hit(10, 1, 1)
	if Input.is_action_just_pressed("DEBUG_HeavyHit"):
		Hit(50, 2, 2)
	
	if Input.is_action_just_pressed("DEBUG_Heal"):
		HP += 1
		$Customize.healSkunk()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_Look()
	_groung_check()
	poise_recharge()
	wall_check()

func _Look():
	var look_dir := Input.get_vector("look.L", "look.R", "look.U", "look.D")
	if look_dir:
		spring_arm_pivot.rotate_y(look_dir.x * (2) * -0.01)
		spring_arm.rotate_x(look_dir.y * (2) * -0.01)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)

func _groung_check(): 
	is_grounded = GroundCheck.is_colliding()
	if is_grounded:
		air_moves = max_air_moves

func Hit(poise : float, damage : int, level : int):
	if !is_intangible:
		if Poise > 0 and level < 2:
			Poise -= poise
			$"Poise lock out".start(3)
		else:
			HP -= damage
			Poise -= poise
			$Customize.woundSkunk()
			$"Poise lock out".start(5)

func poise_recharge():
	if $"Poise lock out".time_left <= 0:
		if Poise <= MaxPoise:
			Poise += 0.1

func wall_check():
	var check1 = $SKUNK_PSX2/metarig/Skeleton3D/wallcheck1
	var canJump1 : bool = false
	var check2 = $SKUNK_PSX2/metarig/Skeleton3D/wallcheck2
	var canJump2 : bool = false
	var check3 = $SKUNK_PSX2/metarig/Skeleton3D/wallcheck3
	var canJump3 : bool = false
	if check1.is_colliding():
			var collider = check1.get_collider()
			if collider.is_in_group("WallJump"):
				canJump1 = true
	if check2.is_colliding():
			var collider = check2.get_collider()
			if collider.is_in_group("WallJump"):
				canJump2 = true
	if check3.is_colliding():
			var collider = check3.get_collider()
			if collider.is_in_group("WallJump"):
				canJump3 = true
	
	if canJump1 and (canJump2 or canJump3):
		can_walljump = true
		#print_debug("TRUE")
	else:
		can_walljump = false
