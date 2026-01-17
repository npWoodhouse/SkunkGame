extends Node

var health : int

var port1 = preload("res://Char/STinker/UI/portrates/SkunkPortrat1.png")
var port2 = preload("res://Char/STinker/UI/portrates/SkunkPortrat2.png")
var port3 = preload("res://Char/STinker/UI/portrates/SkunkPortrat3.png")
var port4 = preload("res://Char/STinker/UI/portrates/SkunkPortrat4.png")
var port5 = preload("res://Char/STinker/UI/portrates/SkunkPortrat5.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../SkunkPortrat".texture = port1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health = $"../../..".HP
	
	if health >= 5:
		$"../SkunkPortrat".texture = port1
	
	if health < 5:
		$"5".visible = false
		$"../SkunkPortrat".texture = port2
	else:
		$"5".visible = true
	
	if health < 4:
		$"4".visible = false
		$"../SkunkPortrat".texture = port3
	else:
		$"4".visible = true
	
	if health < 3:
		$"3".visible = false
		$"../SkunkPortrat".texture = port4
	else:
		$"3".visible = true
	
	if health < 2:
		$"../SkunkPortrat".texture = port5
		$"2".visible = false
	else:
		$"2".visible = true
	
	if health < 1:
		$"1".visible = false
	else:
		$"1".visible = true
