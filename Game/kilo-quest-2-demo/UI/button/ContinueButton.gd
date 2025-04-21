extends Area2D

@export var Sprite: AnimatedSprite2D

var is_hover: bool = false

func _process(delta: float) -> void:
	if is_hover and Input.is_action_just_pressed("attack"):
		Router.emit_signal('load_demo')
		Sprite.play("pressed")
		await Sprite.animation_finished
		# Instead of emitting a signal, change to the loading screen.
		get_tree().change_scene_to_file("res://Levels/loading_screen.tscn")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_hover = false
		Sprite.play("idle")

func _on_body_entered(body: Node2D) -> void:
	print("got mouse")
	if body.is_in_group("player"):
		Sprite.play("hover")
		await Sprite.animation_finished
		Sprite.play("hover-idle")
		is_hover = true


func _on_menu_button_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
