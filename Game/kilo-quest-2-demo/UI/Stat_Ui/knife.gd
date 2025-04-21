extends HBoxContainer

@onready var knives = [
	$Knife1 as Sprite2D,
	$Knife2 as Sprite2D,
	$Knife3 as Sprite2D,
	$Knife4 as Sprite2D,
]

@export var knife_gained_streamer : AudioStreamPlayer2D

var max_knives: int = 4
var current_knives: int = 4

func _ready() -> void:
	SignalBus.connect("knife_thrown", _on_knife_thrown)

func _on_knife_thrown() -> void:
	if current_knives <= 0:
		return

	for i in range(max_knives):
		if knives[i].modulate == Color(1, 1, 1):  # Find first visible knife
			_reload_knife(i)
			current_knives -= 1
			break

func _reload_knife(index: int) -> void:
	var knife_sprite = knives[index]

	# Turn the knife black
	knife_sprite.modulate = Color(0, 0, 0)

	# Wait, then bring it back
	await get_tree().create_timer(4.0).timeout
	knife_sprite.modulate = Color(1, 1, 1)

	current_knives += 1
	SignalBus.emit_signal("knife_gained")
	knife_gained_streamer.play()
