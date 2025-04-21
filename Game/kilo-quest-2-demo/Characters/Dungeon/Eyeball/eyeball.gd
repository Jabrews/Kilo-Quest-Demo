extends CharacterBody2D

var original_position
var health : int = 50

func _ready() -> void:
	original_position = global_position  # Set it on ready
