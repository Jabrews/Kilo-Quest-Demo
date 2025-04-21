extends State
class_name Hit

@export var hit_timer: Timer
@export var character: CharacterBody2D
@export var sprite: AnimatedSprite2D
@export var AttackState: State
@export var DeathState: State
@export var DetectArea : Area2D
@export var EscapeArea : Area2D

func enter():
	
	print(character.health)
	
	if character.health < 0:
		get_parent().change_state(DeathState)
		return # ✅ Prevent the rest of enter() from running
		
	else :
		print('running else for some reasons')
		hit_timer.start()

		sprite.scale = Vector2(1.2, 1.2)
		sprite.modulate = Color(0.6, 0.6, 0.6, 1.0)
		sprite.play("hit")

func update(delta):
	pass
		
func exit():
	sprite.scale = Vector2(1, 1)
	sprite.modulate = Color(1, 1, 1, 1)

func _on_hit_time_timeout() -> void:
	# ✅ Only change state if we're still the current state
	if get_parent().current_state != self:
		return
	get_parent().change_state(AttackState)
