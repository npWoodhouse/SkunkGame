extends State

@export
var sword_Idle: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('throw'):
		return sword_Idle
	return null

@export var ray: RayCast3D
@export var rope: Node3D
@export var PlayerRB: RigidBody3D
@export var cross_hair: MeshInstance3D

@onready var Harpoon = preload("res://Char/Skunk/harpoon.tscn")


var target: Vector3
var knife: Vector3
var knife_instance

var launched = false
var been_instanced = false
var anchor_placed = false

var rest_length: float

var been_launched: bool = false

func _physics_process(delta: float) -> void:
	anchored()
	
	#indicates if a target is in range
	var collision = ray.get_collider()
	if ray.is_colliding():
		if !collision.is_in_group("UnHookable"):
			cross_hair.scale = Vector3(0.04, 0.04, 0.04)
		else:
			cross_hair.scale = Vector3(0.02, 0.02, 0.02)
	else:
		cross_hair.scale = Vector3(0.02, 0.02, 0.02)
	
	#wher a player presses the button
	if Input.is_action_just_pressed("attack.L"):
		launch(collision)
	if Input.is_action_just_released("attack.L"):
		retract()
	
	#if the knif has been put into a target
	if been_instanced:
		handle_grapple(delta)
	
	make_rope()


func launch(collision):
	if ray.is_colliding():
		if !collision.is_in_group("UnHookable"):
			target = ray.get_collision_point()
			been_instanced = true
			knife_instance = Harpoon.instantiate()
			knife_instance.position = target
			knife = knife_instance.position
			add_child(knife_instance)
			launched = true

#this function contains the main logic for the grappling hook state
func handle_grapple(_delta: float):
	#subtracting the players position from where they were aiming the knife
	var direction = knife - PlayerRB.position
	
	if ray.is_colliding():
		var collision = ray.get_collider()
		#if the player is aiming at a physics object:
		if collision.is_in_group("Dynamic_Assets"):
			if !anchor_placed:
				if PlayerRB.is_grounded:
					you_to_me(direction, collision)
				else:
					me_to_you(direction, collision)
		# if the player is aiming at a non physics object
		else:
			rest_length = PlayerRB.position.distance_to(knife)
			anchor_placed = true

# if the player uses the harpoon as an anchor this function will tether them to the selected point
func anchored():
	if anchor_placed:
		var direction = knife - PlayerRB.position
		if PlayerRB.position.distance_to(knife) > rest_length:
			PlayerRB.apply_impulse(direction * (3 * PlayerRB.position.distance_to(knife)))

# after a short delay this function launches the target at the player
func you_to_me(direction , collision):
	if been_launched == false:
		
		collision.linear_velocity = Vector3(0,0,0)
		collision.angular_velocity = Vector3(0,0,0)
		PlayerRB.linear_velocity = Vector3(0,0,0)
		
		var distance = PlayerRB.position.distance_to(knife)
		await get_tree().create_timer(0.5).timeout
		
		collision.apply_impulse(direction * -2 * distance)
		been_launched = true
		hault()
		return

# after a short delay this function launches the player at the target
func me_to_you(direction , collision):
	if been_launched == false:
		
		collision.linear_velocity = Vector3(0,0,0)
		PlayerRB.linear_velocity = Vector3(0,0,0)
		collision.angular_velocity = Vector3(0,0,0)
		
		var distance = PlayerRB.position.distance_to(knife)
		await get_tree().create_timer(0.5).timeout
		
		PlayerRB.apply_impulse(direction * 2 * distance)
		been_launched = true
		hault()
		return

# this function makes a rope appear between the player and the target
func make_rope():
	if !launched:
		rope.scale = Vector3(0, 0, 0)
		been_launched = false
	else:
		var dist = PlayerRB.position.distance_to(knife)
		rope.scale = Vector3(1, 1, dist)
		rope.look_at(knife)

#called to stop the player after they get to their destination
func hault():
	retract()
	await get_tree().create_timer(0.25).timeout
	PlayerRB.linear_velocity = Vector3(0,0,0)
	

#retract is a cleanup function that resets everything that happens during a graple
func retract():
	if been_instanced:
		been_instanced = false
		knife_instance.queue_free()
	launched = false
	anchor_placed = false
	if PlayerRB.position.distance_to(knife) < 5.0:
		PlayerRB.linear_velocity = Vector3(0,0,0)
