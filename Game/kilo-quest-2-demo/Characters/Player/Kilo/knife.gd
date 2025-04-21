extends Area2D

@export var break_particle: CPUParticles2D
@export var sprite: Sprite2D
@export var speed: float = 200.0 # Will be overwritten on spawn
@export var knife_gravity: float = 1000.0

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var initialized := false

signal character_damaged(body, damage)


func _ready() -> void:
	SfxBus.emit_signal('knife_start')

func _physics_process(delta: float) -> void:
	if not initialized and direction.length() > 0 and speed > 0:
		velocity = direction.normalized() * speed
		rotation = velocity.angle()
		initialized = true
		return # Wait until next frame to move

	# Apply gravity to vertical motion
	velocity.y += knife_gravity * delta

	# Move the knife
	global_position += velocity * delta

	# Rotate to match flight path
	rotation = velocity.angle()

func _on_body_entered(body: Node2D) -> void:
	SfxBus.emit_signal("knife_end")
	break_particle.emitting = true
	sprite.visible = false
	set_physics_process(false)
	if body.is_in_group('enemy') :
		SignalBus.emit_signal("character_damaged", body, 50)
	

func _on_break_particle_finished() -> void:
	queue_free()
