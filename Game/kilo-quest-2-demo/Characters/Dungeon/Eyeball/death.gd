extends State
class_name Death

@export var Death_Rattle_Timer : Timer
@export var Death_Timer : Timer
@export var Character : CharacterBody2D
@export var Sprite : AnimatedSprite2D
@export var CpuParticle : CPUParticles2D



@export var death_rattle_move_speed : int = 100
@export var gravity: float = 10.0

var moving_left : bool = false
var fall_speed : float = 0.0

func enter(): 
	SfxBus.emit_signal("eyeball_play", 'fall')
	Death_Timer.start()
	print('death')
	Sprite.play('hit')
	fall_speed = 0.0
	Death_Rattle_Timer.start()

func exit():
	print('exit death')

func update(delta):	
	death_anim(delta)

func death_anim(delta):
	# Wobble
	if moving_left:
		Character.global_position.x -= death_rattle_move_speed * delta
	else:
		Character.global_position.x += death_rattle_move_speed * delta

	# Gravity
	fall_speed += gravity * delta
	Character.global_position.y += fall_speed * delta

func _on_death_rattle_timer_timeout() -> void:
	moving_left = !moving_left


func _on_death_timer_timeout() -> void:
	SfxBus.emit_signal("eyeball_play", 'stop_fall')
	Sprite.visible = false
	CpuParticle.emitting = true
	SfxBus.emit_signal("eyeball_play", 'death_rattle')
	SignalBus.emit_signal('spawn_coins', Character.position, 1.0)



func _on_cpu_particles_2d_finished() -> void:
		Character.queue_free()
