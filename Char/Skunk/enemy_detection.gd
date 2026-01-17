extends Area3D

@export var camera_mount : Node3D

@onready var target = preload("res://Inports/Skunk/Textures/target.png")
@onready var targetLocked = preload("res://Inports/Skunk/Textures/targetLOCKED.png")

var Possible_targets : Array[RigidBody3D]
var target_index : int
var enemy_pos : Vector3

const RANGE : float = 2

var is_looking : bool = false

var is_targeting : bool = false
var grabbing : bool = false

@onready var arrow = $Arrow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target_index = 0
	arrow.visible = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("Wepon_R"):
		if target_index > Possible_targets.size():
			target_index = 0
		else:
			target_index += 1
	
	if Input.is_action_just_pressed("Wepon_L"):
		if target_index < 1:
			target_index = Possible_targets.size()-1
		else:
			target_index -= 1
	
	if Input.is_action_just_pressed("Look"):
		is_looking = true
	if Input.is_action_just_released("Look"):
		is_looking = false
	
	if Input.is_action_just_pressed("Target"):
		if !is_targeting:
			$Arrow.texture = targetLocked
			is_targeting = true
			return
		if is_targeting==true:
			$Arrow.texture = target
			is_targeting = false
			return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print_debug(Possible_targets)
	if Possible_targets.size() < 1:
		is_targeting = false
		$Arrow.texture = target
	
	find_targets()
	
	target_enemy()

func find_targets():
	Possible_targets.clear()
	for obj in self.get_overlapping_bodies():
		if obj.is_in_group("ENEMY"):
			#var xOffset = obj.global_position.x - absf($"..".global_position.x)
			#var yOffset = obj.global_position.y - absf($"..".global_position.y)
			#if Vector3(xOffset, 0, yOffset) < Vector3(RANGE,RANGE,RANGE):
			Possible_targets.append(obj)

func target_enemy():
	if Possible_targets.size() > 0:
		arrow.visible = true
		fix_index()
		var enemy = Possible_targets[target_index]
		arrow.position = (enemy.global_position - $"..".global_position)# + Vector3(0,3,0)
		enemy_pos = Vector3(enemy.global_position.x, 0, enemy.global_position.z)
		#print_debug(enemy)
		look_at_target()
	else:
		arrow.visible = false

func fix_index():
	if target_index >= Possible_targets.size():
		target_index = 0

func look_at_target():
	if !grabbing:
		if is_looking:
			var look_pos = Vector3(enemy_pos.x,camera_mount.position.y,enemy_pos.z)
			camera_mount.look_at(look_pos, Vector3.UP)
