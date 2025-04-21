extends Area2D

# -- Coin properties --
var facing_direction: String 
var amount: float
var type: String = "default"
var starting_pos: Vector2

# -- Movement properties --
@export var initial_speed: float = 300.0   # Initial speed magnitude (pixels per second)
@export var angle: float = 60.0            # Launch angle in degrees (0 = horizontal, 90 = straight up)
@export var grav: float = 600.0            # Gravity acceleration (pixels per second squared)

@export var particle : CPUParticles2D
@export var Sprite : AnimatedSprite2D
@export var CollectDelayTimer : Timer

# Internal velocity vector
var velocity: Vector2

# Flag to control movement
var not_static: bool = true

func _ready() -> void:
	CollectDelayTimer.start()
	# Randomize the offset (make sure the random generator is seeded)
	randomize()
	# Get a random offset between 3 and 7 on the x axis
	var random_offset = randf_range(3, 30)
	# Reverse the offset if facing left
	if facing_direction == "left":
		random_offset = -random_offset
	# Set the coin's starting position with the random x offset
	position = starting_pos + Vector2(random_offset, 0)
	
	# Convert the launch angle from degrees to radians
	var rad_angle = deg_to_rad(angle)
	
	# Determine horizontal multiplier based on facing direction
	var direction_multiplier = 1 if facing_direction == "right" else -1
	
	# Calculate the initial velocity vector.
	# Note: In Godot, a negative y value means upward.
	velocity = Vector2(initial_speed * cos(rad_angle) * direction_multiplier,
					   -initial_speed * sin(rad_angle))

func _process(delta: float) -> void:
	if not_static:
		# Apply gravity to the vertical component
		velocity.y += grav * delta
		# Update the position based on velocity
		position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		particle.emitting = true
		Sprite.visible = false
		SignalBus.emit_signal('coin_got', amount)
		SfxBus.emit_signal('coin_collected')
	else:
		# Stop movement if colliding with something other than the player
		not_static = false
		velocity = Vector2.ZERO


func _on_cpu_particles_2d_finished() -> void:
	queue_free()


func _on_collect_delay_timer_timeout() -> void:
	collision_mask |= (1 << 1)
