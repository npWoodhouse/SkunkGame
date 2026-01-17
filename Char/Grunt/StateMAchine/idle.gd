extends Enemy_State

@export var Chase: Enemy_State
@export var Startle: Enemy_State
@export var ded: Enemy_State

@export var Personal_space : Area3D

@export var LOS : RayCast3D

func state_process(delta):
	if parent.HP <= 0:
		state_Machine.change_state(ded)
	playerdetection()

#func enter():
	#$"../../PlayerPosDebug".visible = false
	#$"../../PathDebug".visible = false

func playerdetection():
	#if parent.hasSpaceLOS:
		#state_Machine.change_state(Startle)
	if parent.hasLOS:
		var target_distance : float = Vector2(parent.global_position.x,parent.global_position.z).distance_to(Vector2(parent.Target_POS.x,parent.Target_POS.z))
		if parent.ALERT == false:
			if target_distance > 10:
				state_Machine.change_state(Chase)
			if target_distance <= 10:
				state_Machine.change_state(Startle)
		if parent.ALERT == true:
			state_Machine.change_state(Chase)
