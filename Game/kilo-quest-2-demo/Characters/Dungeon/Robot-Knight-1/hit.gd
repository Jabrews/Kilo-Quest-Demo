extends State

class_name KnightHit

@export var character : CharacterBody2D
@export var DeathState : State
@export var AttackState : State

@export var HitPauseTimer : Timer
@export var CenterHurtBox : Area2D
@export var Sprite : AnimatedSprite2D



func enter():
	print('Knight Entered HIT')
	if character.health < 0:
		get_parent().change_state(DeathState)
		return # ✅ Prevent the rest of enter() from running
		
	Sprite.play('hit')
	SfxBus.emit_signal('knight_play', 'hit')
	HitPauseTimer.start()
	character.start_grace_period()

		

func exit():
	print("Knight Exited HIT")

func update(_delta):
	CenterHurtBox.monitoring = false


func _on_hit_pause_timer_timeout() -> void:
	if get_parent().current_state != self:
		return
	get_parent().change_state(AttackState)
