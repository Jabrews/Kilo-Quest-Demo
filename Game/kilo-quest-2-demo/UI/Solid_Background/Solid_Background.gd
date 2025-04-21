extends ColorRect

@export var player: CharacterBody2D 

var slider_lock : bool = false

func _ready():
	size = get_viewport_rect().size * 2

func _process(delta):
	if player:
		global_position = player.global_position - size / 2  # Center the background on the player
