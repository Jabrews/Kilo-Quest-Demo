extends CanvasLayer

@export var death_sprite : CompressedTexture2D

func _ready() -> void:
	SignalBus.connect('player_death', show_circle_effect)
		
func show_circle_effect() :
	# Create a new CanvasLayer to ensure the effect is on top
	var canvas = CanvasLayer.new()
	canvas.layer = 100  # Ensure it's above other elements	 get_tree().get_root().add_child(canvas)
	
	# Create and configure the Light2D node
	var circle_light = Light2D.new()
	circle_light.texture = preload("res://path_to_your_circle_texture.png")
	circle_light.mode = Light2D.MODE_MASK  # This will mask (or darken) areas outside the circle
	
	# Position the light at the center of the viewport (or at Player.global_position)
	circle_light.global_position = get_viewport().size / 2
	# Alternatively, to follow the player:
	# circle_light.global_position = Player.global_position
	
	# Adjust the scale if needed to control the circle's size
	circle_light.scale = Vector2(1.0, 1.0)
	
	# Add the light to the CanvasLayer
	canvas.add_child(circle_light)
