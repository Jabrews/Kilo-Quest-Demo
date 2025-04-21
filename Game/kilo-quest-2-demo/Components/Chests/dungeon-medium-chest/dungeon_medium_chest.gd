extends Area2D

@export var total_coins : float

var in_open_range : bool = false
var is_opened : bool = false

@export var Sprite : AnimatedSprite2D

func _process(delta: float) -> void:
	if in_open_range == true and is_opened == false:
		if Input.is_action_just_pressed('secondary-action') || Input.is_action_just_pressed("attack"):
			SfxBus.emit_signal('chest_open')
			SignalBus.emit_signal("spawn_coins", global_position, total_coins)
			Sprite.play('open')
			is_opened = true
			await Sprite.animation_finished
			Sprite.play('finished')

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		if is_opened == false:
			in_open_range = true
			


func _on_body_exited(body: Node2D) -> void:
	in_open_range = false
