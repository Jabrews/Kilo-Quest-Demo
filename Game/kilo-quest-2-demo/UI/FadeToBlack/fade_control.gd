extends Control

@export var Sprite: Sprite2D
@export var Player: CharacterBody2D

var is_active : bool = false

func _ready() -> void:
	# Set sprite's alpha to 0 (completely transparent) using modulate.
	Sprite.modulate = Color(1, 1, 1, 0)
	Sprite.visible = false
	# Connect the "fade_to_black" signal to _on_fade_to_black using a Callable.
	SignalBus.connect("fade_to_black", Callable(self, "_on_fade_to_black"))

func _on_fade_to_black():
	Sprite.visible = true
	# Position the sprite at the player's current position.
	is_active = true
	# Create a tween that will animate the sprite's modulate alpha from 0 to 1.
	var tween = create_tween()
	var target_color = Sprite.modulate  # Copy current modulate color.
	target_color.a = 1.0                # Set full opacity (alpha = 1).
	tween.tween_property(Sprite, "modulate", target_color, 1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://Levels/death_screen.tscn")


func _process(delta: float) -> void:
	if is_active == true :
		Sprite.position = Player.position
