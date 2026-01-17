extends Area3D

@onready var Shape = $CollisionShape3D

var poise : float
var dmg : int
var lvl : int

# Called when the node enters the scene tree for the first time.
func set_shape(SIZE : float = 0, POISE : float = 0, DMG : int  = 0, LVL : int = 0):
	#Shape.shape.radius = SIZE
	poise = POISE
	dmg = DMG
	lvl = LVL

func _process(delta: float) -> void:
	if $Timer.time_left <= 0:
		self.queue_free()
	hit_check()

func hit_check():
	#print_debug("Check")
	for bodies in self.get_overlapping_bodies():
		if bodies.is_in_group("Players"):
			#print_debug("HIT")
			bodies.Hit(poise, dmg, lvl)
			self.queue_free()
