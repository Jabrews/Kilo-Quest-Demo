extends Sprite2D

var placement_pos: Vector2
var face_left: bool = false

var fade_timer := 0.0
var fade_duration := 0.5  # Seconds

func _ready() -> void:
	global_position = placement_pos
	flip_h = face_left

func _process(delta: float) -> void:
	if fade_timer < fade_duration:
		fade_timer += delta
		var t := fade_timer / fade_duration

		var start_color := Color(1, 1, 1, 1)
		var end_color := Color(1, 0, 1, 0)
		modulate = start_color.lerp(end_color, t)
