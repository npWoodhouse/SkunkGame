extends Node

var skunk = preload("res://Char/Skunk/materials/Skunk.tres")
var wound = preload("res://Char/Skunk/materials/SkunkWounded.tres")

@export var Parent : Node3D
var Parts: Array[MeshInstance3D]
var hurtParts: Array[MeshInstance3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_tree().get_nodes_in_group("Woundable"):
		if is_instance_of(child, MeshInstance3D):
			child.set_surface_override_material(0, skunk)
			Parts.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print_debug(Parts.size())

func _unhandled_input(event):
	if Input.is_action_just_pressed("DEBUG_Wound"):
		woundSkunk()
	if Input.is_action_just_pressed("DEBUG_Heal"):
		healSkunk()

func woundSkunk():
	if Parts.size() > 0:
			var index = randi_range(0, Parts.size()-1)
			Parts[index].set_surface_override_material(0, wound)
			hurtParts.append(Parts[index])
			Parts.remove_at(index)

func healSkunk():
	if hurtParts.size() > 0:
		var index = randi_range(0, hurtParts.size()-1)
		hurtParts[index].set_surface_override_material(0, skunk)
		Parts.append(hurtParts[index])
		hurtParts.remove_at(index)
