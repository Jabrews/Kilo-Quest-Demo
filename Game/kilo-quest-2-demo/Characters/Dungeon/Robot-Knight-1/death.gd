extends State

class_name KnightDeath

@export var Character : CharacterBody2D
@export var Sprite : AnimatedSprite2D
@export var Particle : CPUParticles2D

func enter():	
	print("enter Knight DEATH")
	Sprite.play('death')
	await Sprite.animation_finished
	SignalBus.emit_signal('spawn_coins', Character.position, 1.0)
	Sprite.visible = false
	Particle.emitting = true
	SfxBus.emit_signal('knight_play', 'death')
	await Particle.finished
	Character.queue_free()

func exit():
	print(" exit Knight DEATH")

func update(_delta):
	pass
