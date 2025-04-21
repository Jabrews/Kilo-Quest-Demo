extends State

class_name KnightIdle

@export var Character: CharacterBody2D
@export var SPEED: float = 100.0
@export var roam_offset: float = 50.0

## Timers (set these up in the scene)
@export var WalkTimer: Timer
@export var PauseTimer: Timer

var original_position: Vector2
var roam_direction: int = 1  # 1: move right; -1: move left.
var is_walking: bool = false
var pending_flip: int = 1  # Store the pending new direction.

@export var Sprite: AnimatedSprite2D
@export var AttackState: State

var animation_lock: bool = false

func enter():
	if Character.get_on_screen():
		SfxBus.emit_signal('knight_play', 'walk')
	original_position = Character.global_position
	print("Knight is in IDLE")
	# Start with the walk phase instead of pause.
	is_walking = true
	WalkTimer.start()

func exit():
	print("Knight Exit IDLE")
	WalkTimer.stop()
	PauseTimer.stop()
	
func update(delta):
	# If we haven't gotten the original position, do nothing.
	if original_position == null:
		return
		
	#if Character.velocity.x == 0 :
		#SfxBus.emit_signal('stop_knight_walk')

	
	# If walking, update the roaming movement.
	if is_walking:
		roam(delta)
		
	Character.move_and_slide()
	
# This function updates the character's position during the walk phase.
func roam(delta):	
	if roam_direction == 1:
		Sprite.play("walk")
		# Move right.
		Character.position.x += SPEED * delta
		# Check if we've reached the right offset.
		if Character.position.x >= original_position.x + roam_offset:
			Character.position.x = original_position.x + roam_offset
			WalkTimer.stop()  # Stop the timer since we've reached the target.
			_on_walk_timer_timeout()
	elif roam_direction == -1:
		if animation_lock == false:
			Sprite.play("walk")
		# Move left.
		Character.position.x -= SPEED * delta
		# Check if we've reached the left offset.
		if Character.position.x <= original_position.x - roam_offset:
			Character.position.x = original_position.x - roam_offset
			WalkTimer.stop()
			_on_walk_timer_timeout()

# Called when the walk timer finishes (or if we stop it early because the target is reached).
func _on_walk_timer_timeout() -> void:
	animation_lock = true
	is_walking = false
	# Instead of flipping immediately, store the pending flip.
	pending_flip = -roam_direction
	# Play the get_down animation to begin the idle pause.
	if Character.get_on_screen():
		SfxBus.emit_signal('stop_knight_walk')
	Sprite.play("get_down")
	PauseTimer.start()
	await Sprite.animation_finished
	Sprite.play("down")
	# Start the pause phase.
	
# Called when the pause timer finishes.
func _on_pause_timer_timeout() -> void:
	Sprite.play("get_up")
	if Character.get_on_screen():
		SfxBus.emit_signal('knight_play' ,'sword-up')
	# Wait until the "get_up" animation finishes.
	await Sprite.animation_finished
	# Now that the animation is done, update the roaming direction.
	animation_lock = false
	roam_direction = pending_flip
	if roam_direction == -1:
		Character.flip_sprite("left")
	else:
		Character.flip_sprite("right")
	is_walking = true
	WalkTimer.start()
	if Character.get_on_screen():
		SfxBus.emit_signal('knight_play', 'walk')

func _detect_player() :
	get_parent().change_state(AttackState)
