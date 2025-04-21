extends Area2D

@export var speed: float = 500  # Speed of the bullet
@export var starting_position: Vector2  # The starting position of the bullet
@export var target_position: Vector2  # The target position for the bullet

# Dust Particle
@export var Dust : CPUParticles2D

# Sprite
@export var Sprite : Sprite2D

var direction: Vector2
var moving: bool = true  # Tracks if the bullet is moving towards the target

func _ready():
	SfxBus.emit_signal("eyeball_play", 'shoot_start')
	
	# Set the bullet's starting position
	position = starting_position 
	
	# Calculate direction from starting position to target position
	direction = (target_position - starting_position).normalized()

func _process(delta):
	if moving:
		# Move towards the target position
		var move_step = direction * speed * delta
		position += move_step
		
		# Check if the bullet has passed the target
		if position.distance_to(target_position) < speed * delta:
			moving = false  # Stop adjusting direction, let it continue forward
	else:
		# Continue in the same direction indefinitely
		position += direction * speed * delta

func _on_body_entered(body):
	SfxBus.emit_signal("eyeball_play", 'shoot_end')
	if body.is_in_group('player'):
		SignalBus.emit_signal("player_damaged")
	# Start particle effect
	Dust.emitting = true
	Sprite.visible = false

	
	# Wait a short moment before freeing the bullet
	await get_tree().create_timer(0.1).timeout
	queue_free()
