extends State

@export var Land: State
@export var Jump: State
@export var Sword_air_L1: State
@export var Sword_air_R1: State
@export var Sword_Hold: State
@export var Swing: State
@export var me_to_you: State
@export var Dash: State

@export var RB: RigidBody3D
@export var State_Machine: Node

#other references
var checking : bool
@export var ray: RayCast3D
@export var rope: Node3D
@export var PlayerRB: RigidBody3D
@export var cross_hair: MeshInstance3D


func enter():
	checking = true
	character_RigidBody.is_falling = true
	animation_player.play(animation_name)

func _process(delta):
	if character_RigidBody.is_grounded and checking:
		checking = false
		$"..".change_state(Land)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return Jump
	if Input.is_action_just_pressed("dash"):
		return Dash
	
	if character_RigidBody.WeponStance == 0:
		if Input.is_action_just_pressed("attack.L"):
			return Sword_air_L1
		if Input.is_action_just_pressed("attack.R"):
			return Sword_air_R1
	
	#in harpoon Stance
	if character_RigidBody.WeponStance == -1:
		if Input.is_action_just_pressed("attack.L"):
			var collision = ray.get_collider()
			if ray.is_colliding():
				if !collision.is_in_group("UnHookable"):
					character_RigidBody.target = ray.get_collision_point()
					character_RigidBody.direction = character_RigidBody.target - PlayerRB.position
					character_RigidBody.rest_length = PlayerRB.position.distance_to(character_RigidBody.target)
					character_RigidBody.anchor_placed = true
					return Swing
		if Input.is_action_just_pressed("attack.R"):
			var collision = ray.get_collider()
			if ray.is_colliding():
				if !collision.is_in_group("UnHookable"):
					character_RigidBody.target = ray.get_collision_point()
					character_RigidBody.direction = character_RigidBody.target - PlayerRB.position
					if collision.is_in_group("Dynamic_Assets"):
							if !character_RigidBody.anchor_placed:
								character_RigidBody.anchor_placed = true
								character_RigidBody.collision = collision
								return me_to_you
	return null

func exit():
	checking = false
