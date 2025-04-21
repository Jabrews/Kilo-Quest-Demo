extends State

class_name Attack

# Bullet Scene
var BulletScene = preload("res://Characters/Dungeon/Eyeball/bullet.tscn")
var moving_right : bool = false
var has_bullet : bool = true

# Components 
var Player : CharacterBody2D = null
@export var DetectPlayer : Node
@export var Character : CharacterBody2D 
@export var IdleState : State
@export var Sprite : AnimatedSprite2D
@export var ShootDelayTimer : Timer

# Movement settings
@export var horizontal_speed: float = 100.0  # Speed for X-axis movement
@export var vertical_speed: float = 150.0    # Speed for Y-axis movement (vertical follow speed)
@export var hover_height: float = 50.0         # Distance above the player to hover

# State variables
var original_position : Vector2
var triggered_animation_finished = false
var ready_to_reload = false
var timer_started: bool = false  

func enter(): 
	SfxBus.emit_signal("eyeball_play", 'agro')
	Sprite.play('triggered')
	original_position = Character.global_position  
	Player = DetectPlayer.get_player()

func exit(): 
	Player = null
	triggered_animation_finished = false
	ready_to_reload = false
	ShootDelayTimer.start()

func update(delta):	
	if Player != null:
		followPlayerAbove(delta)
	if triggered_animation_finished:
		shoot(delta)

	Character.move_and_slide()

func followPlayerAbove(delta):
	# Follow player's X position and hover above on the Y-axis
	if Player != null:
		var target_x = Player.global_position.x
		var target_y = Player.global_position.y - hover_height  # Maintain fixed distance above the player
		
		# Smoothly move toward the target position
		Character.global_position.x = move_toward(Character.global_position.x, target_x, horizontal_speed * delta)
		Character.global_position.y = move_toward(Character.global_position.y, target_y, vertical_speed * delta)

		# Flip sprite based on horizontal movement
		if target_x > Character.global_position.x:
			moving_right = true
			Sprite.flip_h = false  # Facing right
		else:
			moving_right = false
			Sprite.flip_h = true   # Facing left
	else:
		get_parent().change_state(IdleState)

func _end_chase():
	get_parent().change_state(IdleState)

func shoot(delta):
	if ready_to_reload:
		Sprite.play("reload")
		has_bullet = true
	else:
		Sprite.play("shoot")
		if has_bullet:
			spawn_bullet()
		# Start the timer only if it hasn't started yet
		if not timer_started:
			timer_started = true  
			ShootDelayTimer.start()

func spawn_bullet(): 
	var bullet = BulletScene.instantiate()  
	bullet.target_position = Player.global_position  
	bullet.starting_position = Character.global_position + Vector2(0, 15)
	get_parent().add_child(bullet)  
	has_bullet = false

func _on_shoot_delay_timer_timeout() -> void:
	ready_to_reload = true
	timer_started = false  

func _on_animated_sprite_2d_animation_finished() -> void:
	# Turns off the bool stopping the shooting mechanic 
	if Sprite.animation == 'triggered':
		triggered_animation_finished = true
	if Sprite.animation == 'reload':
		ready_to_reload = false
