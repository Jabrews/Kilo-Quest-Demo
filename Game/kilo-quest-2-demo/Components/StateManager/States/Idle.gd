extends State

class_name Idle

## Components
var StateManager: Node = null
@export var Character: CharacterBody2D
@export var DetectPlayer: Node
@export var AttackState: State 
@export var Sprite : AnimatedSprite2D
@export var DirectionTimer : Timer

@export var hurtbox_move_distance: float = 10.0  # Distance to move up/down
@export var hurtbox_move_speed: float = 50.0  # Speed of movement (in pixels per second)
@export var speed: float = 100.0  # X-axis speed

var original_position_y: float
var original_position_x : float
var moving_up: bool = true

func enter():
	Sprite.play('idle')
	original_position_y = Character.global_position.y  # Store original Y position
	original_position_x = Character.global_position.x  # Store original X position
	DirectionTimer.start()
	
	
	
func exit():
	# Stop the timer when leaving the state
	DirectionTimer.stop()

func update(delta):
	if round(Character.global_position.x) < round(original_position_x):
		returnToIdlePos(delta)
	_move_character(delta)
	_detect_player()

func _move_character(delta: float) -> void:
	# Use velocity instead of directly modifying position
	var direction = -1 if moving_up else 1  # -1 for up, 1 for down
	Character.velocity.y = direction * hurtbox_move_speed

	# Apply movement using physics
	Character.move_and_slide()

func _detect_player():
	if DetectPlayer and DetectPlayer.get_player():  # Ensure DetectPlayer is valid and detecting the player
		get_parent().change_state(AttackState)

func returnToIdlePos(delta) :
	var difference = original_position_x - Character.global_position.x
	Character.global_position.x += difference * speed * delta

# Timer function to toggle movement direction
func _on_direction_timer_timeout() -> void:
	moving_up = !moving_up  # Flip movement direction
