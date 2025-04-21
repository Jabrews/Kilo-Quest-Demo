extends Area2D

var is_hover: bool = false
@onready var sprite = $Sprite2D

func _ready() -> void:
	scale = Vector2(1, 1)

func _process(delta: float) -> void:
	if is_hover:
		scale = scale.lerp(Vector2(2, 2), 0.1)
	else:
		scale = scale.lerp(Vector2(1, 1), 0.1)
		
	if is_hover and Input.is_action_just_pressed("attack"):
		get_parent().emit_signal('create_settings_instance')

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_hover = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_hover = true
