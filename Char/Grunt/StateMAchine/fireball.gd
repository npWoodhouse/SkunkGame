extends Enemy_State

@onready var fireL = $"../../CollisionShape3D/metarig/Skeleton3D/hand02_L/AnimatedSprite3D"
@onready var fireR = $"../../CollisionShape3D/metarig/Skeleton3D/hand02_R/AnimatedSprite3D2"
@onready var rig = $"../../CollisionShape3D"
@onready var FIREBALL = preload("res://Char/Grunt/FIREBALL/fireball.tscn")

@export var Fire: Enemy_State
@export var Stand: Enemy_State

func state_process(delta):
	var direction := (parent.Target_POS - parent.global_position).normalized()
	direction = direction.rotated(Vector3.UP, parent.rotation.y) * parent.MoveForce
	
	if direction:
		parent.theta = wrapf(atan2(direction.x, direction.z) - parent.rig.rotation.y, -PI, PI)
		parent.rig.rotation.y += clamp(parent.rotation_speed * delta, 0, abs(parent.theta) * sign(parent.theta))
	else:
		pass

func spritesON():
	fireL.play("default")
	fireR.play("default")
	fireL.visible = true
	fireR.visible = true

func LspritesOFF():
	fireL.visible = false
	var fireball = FIREBALL.instantiate()
	fireball.global_position = fireL.global_position
	fireball.rotation = rig.rotation
	add_child(fireball)

func RspritesOFF():
	fireR.visible = false
	var fireball = FIREBALL.instantiate()
	fireball.global_position = fireR.global_position
	fireball.rotation = rig.rotation
	add_child(fireball)

func next():
	var roll : int = randi_range(0,2)
	if roll == 2:
		state_Machine.change_state(Fire)
	else:
		state_Machine.change_state(Stand)
