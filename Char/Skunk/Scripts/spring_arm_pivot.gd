extends Node3D

@onready var LookSense = 10

@export var spring_arm: SpringArm3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#func _unhandled_input(event):
#	if event is InputEventMouseMotion:
#		self.rotate_y(-event.relative.x * 0.005)
#		spring_arm.rotate_x(-event.relative.y * 0.005)
#		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)

#func _Look():
#	if Input.is_action_pressed("look.L"):
#		self.rotate_y(LookSense * 0.005)
#	if Input.is_action_pressed("look.R"):
#		self.rotate_y(-LookSense * 0.005)
#	if Input.is_action_pressed("look.U"):
#		spring_arm.rotate_x(LookSense * 0.005)
#		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)
#	if Input.is_action_pressed("look.D"):
#		spring_arm.rotate_x(-LookSense * 0.005)
#		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, PI/2)
