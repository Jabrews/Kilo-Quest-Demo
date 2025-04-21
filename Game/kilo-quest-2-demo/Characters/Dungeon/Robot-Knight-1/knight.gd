extends CharacterBody2D

var health : int = 50

#org pos
signal original_position_signal(position)
signal KnightHit()

#sprite flip
@export var Sprite : AnimatedSprite2D
@export var HurtboxR : CollisionShape2D
@export var HurtboxL : CollisionShape2D
@export var ConeDetectL : CollisionShape2D
@export var ConeDetectR : CollisionShape2D
@export var SwordL : CollisionShape2D
@export var SwordR : CollisionShape2D

#visibitly 
@export var VisibleScreen : VisibleOnScreenNotifier2D

# Timers
@export var GraceTimer : Timer
@export var Blink : Timer
@export var CenterHurtBox : Area2D

var speed = 200
var is_in_grace = false


func _ready() -> void:
	flip_sprite('right')
	
	
func _process(delta: float) -> void:
	velocity.y += get_gravity().y * delta
	move_and_slide()
	
	
func flip_sprite(direction):
	if direction == 'right' :
		Sprite.flip_h = false
		HurtboxL.visible = false
		HurtboxR.visible = true
		ConeDetectL.visible = false
		ConeDetectR.visible = true
		SwordR.visible = true
		SwordL.visible = false
		
	elif direction == 'left':
		Sprite.flip_h = true
		HurtboxL.visible = true
		HurtboxR.visible = false
		ConeDetectL.visible = true
		ConeDetectR.visible = false
		SwordR.visible = false
		SwordL.visible = true
		
func start_grace_period():
	CenterHurtBox.visible = false
	is_in_grace = true
	# Disable collision on layer 3 (bit index 2) so the character is temporarily invulnerable
	set_collision_layer_value(3, false)
	# Start the grace period timer; when it times out, collisions will be re-enabled
	GraceTimer.start()
	# Start the blink timer to make the sprite blink
	Blink.start()

func _on_grace_timer_timeout() -> void:
	CenterHurtBox.visible = true
	is_in_grace = false
	# Re-enable collision on layer 3 now that the grace period is over
	set_collision_layer_value(3, true)
	# Stop the blink timer so the sprite stops blinking
	Blink.stop()
	# Ensure the sprite is visible at the end of the grace period
	Sprite.visible = true

func _on_blink_timer_timeout() -> void:
	# Toggle the sprite's visibility to create a blinking effect
	Sprite.visible = not Sprite.visible

func get_is_in_grace():
	return is_in_grace
	
func get_speed():
	return speed
	
func get_on_screen():
	return VisibleScreen.is_on_screen()
