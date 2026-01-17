extends State

#states
@export var State_Machine: Node
@export var Hold: State
@export var swing: State
@export var you_to_me: State
@export var SwordL1: State
@export var SwordH1: State
@export var Fall: State
@export var Jump: State
@export var Dash: State

@export var Punch: State
@export var HeavyPunch: State

#other references
@export var ray: RayCast3D
@export var rope: Node3D
@export var cross_hair: MeshInstance3D

var can_aim: bool

func process_input(event: InputEvent) -> State:
	if !character_RigidBody.is_grounded:
		State_Machine.change_state(Fall)
	if Input.is_action_just_pressed("jump"):
		return Jump
	if Input.is_action_just_pressed("dash"):
		return Dash
	
	#if the player starts moving
	#if !character_RigidBody.is_moving:
	#	return Hold
	
	#in Guantlet Stance
	if character_RigidBody.WeponStance == 1:
		if Input.is_action_just_pressed("attack.L"):
			return Punch
		if Input.is_action_just_pressed("attack.R"):
			return HeavyPunch
	
	#in Sword Stance
	if character_RigidBody.WeponStance == 0:
		if Input.is_action_just_pressed("attack.L"):
			return SwordL1
		if Input.is_action_just_pressed("attack.R"):
			return SwordH1
	
	#in harpoon Stance
	if character_RigidBody.WeponStance == -1:
		if Input.is_action_just_pressed("attack.L"):
			var collision = ray.get_collider()
			if ray.is_colliding():
				if !collision.is_in_group("UnHookable"):
					character_RigidBody.target = ray.get_collision_point()
					character_RigidBody.direction = character_RigidBody.target - character_RigidBody.position
					character_RigidBody.rest_length = character_RigidBody.position.distance_to(character_RigidBody.target)
					character_RigidBody.anchor_placed = true
					return swing
		if Input.is_action_just_pressed("attack.R"):
			var collision = ray.get_collider()
			if ray.is_colliding():
				if !collision.is_in_group("UnHookable"):
					character_RigidBody.target = ray.get_collision_point()
					character_RigidBody.direction = character_RigidBody.target - character_RigidBody.position
					if collision.is_in_group("Dynamic_Assets"):
							if !character_RigidBody.anchor_placed:
								character_RigidBody.anchor_placed = true
								character_RigidBody.collision = collision
								return you_to_me
							#if PlayerRB.is_grounded:
							#	State_Machine.anchor_placed = true
							#	State_Machine.collision = collision
							#	return you_to_me
							#else:
							#	State_Machine.anchor_placed = true
							#	State_Machine.collision = collision
							#	return me_to_you
	return null

#func _physics_process(delta: float) -> void:
	#PlayerRB.apply_impulse($"../../SKUNK_PSX2/Forward".target_position*5)

func exit() -> void:
	cross_hair.scale = Vector3(0.02, 0.02, 0.02)
	can_aim = false
