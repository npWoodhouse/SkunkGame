extends Area3D

@onready var Shape = $CollisionShape3D
@export var point : Node3D

var poise : float
var dmg : int
var lvl : int

var parent: Node3D
var power: float

func set_shape(SIZE : float = 0, POISE : float = 0, DMG : int  = 0, LVL : int = 0):
	#Shape.shape.radius = SIZE
	poise = POISE
	dmg = DMG
	lvl = LVL

func _process(delta: float) -> void:
	if $Timer.time_left <= 0:
		self.queue_free()
	#Physics_check()
	hit_check()

func Physics_check():
	self.position = parent.global_position
	self.rotation = parent.rotation
	for obj in self.get_overlapping_bodies():
		if obj.is_in_group("Dynamic_Assets"):
			var direction: Vector3 = obj.global_position - point.global_position
			var force: float = -1 * obj.global_position.distance_to(point.global_position)
			obj.apply_impulse(direction * force* power)

func hit_check():
	#print_debug("Check")
	for bodies in self.get_overlapping_bodies():
		if bodies.is_in_group("ENEMY"):
			print_debug("HIT")
			bodies.Hit(poise, dmg, lvl)
			self.queue_free()
