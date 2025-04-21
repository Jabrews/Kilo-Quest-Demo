extends CharacterBody2D

@export var TurnTimer : Timer
@export var speed : float 
@export var Sprite : AnimatedSprite2D
var is_facing_right : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TurnTimer.start()


func _process(delta: float) -> void:
	if is_facing_right == true:
		Sprite.flip_h = false
		velocity.x += speed * delta
	elif is_facing_right == false :
		Sprite.flip_h = true
		velocity.x += -speed * delta
		
		
	move_and_slide()
		


func _on_turn_timer_timeout() -> void:
	velocity= Vector2.ZERO
	TurnTimer.start()
	is_facing_right = !is_facing_right
