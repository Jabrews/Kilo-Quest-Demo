extends State

class_name KnightAttack

var SPEED: float = 150.0

#components 
var Player : CharacterBody2D = null
@export var DetectPlayer : Node
@export var Character : CharacterBody2D 
@export var IdleState : State
@export var Sprite : AnimatedSprite2D

var is_attacking : bool = false
var player_in_sword : bool = false


func enter():	
	if Character.get_on_screen():
		SfxBus.emit_signal('knight_play', 'walk')
	print("Knight is in ATTACk")
	Player = DetectPlayer.get_player()
	print('knight got player : ', Player)

func exit():
	print("Knight leave ATTACk")
	Player = null
	SfxBus.emit_signal('stop_knight_walk')

func update(_delta):
	
	if Player != null:
		
		if is_attacking == false :
			
			Sprite.play('walk')
		
			var target_x = Player.global_position.x
			

			
			# Smoothly move toward the target position
			if Character.get_is_in_grace() == true:
				Character.global_position.x = move_toward(Character.global_position.x, target_x, Character.get_speed() * _delta)
			elif Character.get_is_in_grace() == false:
				Character.global_position.x = move_toward(Character.global_position.x, target_x, SPEED * _delta)
			
			if target_x > Character.global_position.x:
				Character.flip_sprite('right')
			else:
				Character.flip_sprite('left')
				
		else :
			Character.velocity = Vector2.ZERO
			Sprite.play('attack1')
			if Character.get_on_screen():
				SfxBus.emit_signal('knight_play', 'walk')
			SfxBus.emit_signal('knight_play', 'attack')
			await Sprite.animation_finished
			if player_in_sword == true :
				SignalBus.emit_signal('player_damaged')
			is_attacking = false


func _end_chase():
	get_parent().change_state(IdleState)


func _on_sword_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		is_attacking = true
		player_in_sword = true


func _on_sword_body_exited(body: Node2D) -> void:
	if body.is_in_group('player'):
		player_in_sword = false


func _on_center_hurt_box_body_entered(body: Node2D) -> void:
	SignalBus.emit_signal('player_damaged')
