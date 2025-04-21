extends PathFollow2D

var progress_speed: float = 0.2

func _process(delta):
	progress_ratio = fposmod(progress_ratio + progress_speed * delta, 1.0)
