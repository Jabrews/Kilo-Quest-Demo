extends Node

## components
@export var activate_state : State 
@export var chase_state : State 

## death state0
@export var death_state : State
@export var state_manager : StateManager

## this is what other components should access
var Player : CharacterBody2D = null
	


func _on_detection_area_body_entered(body: Node2D) -> void:
	if state_manager.current_state == death_state :
		return
	else : 
		if body.is_in_group('player') :
			Player = body
			activate_state._detect_player()
		
	
func get_player() :
	return Player

func _on_escape_area_body_exited(body: Node2D) -> void:
	if state_manager.current_state == death_state :
			return
	else : 
		if body.is_in_group('player') :
			Player = null
			chase_state._end_chase()
