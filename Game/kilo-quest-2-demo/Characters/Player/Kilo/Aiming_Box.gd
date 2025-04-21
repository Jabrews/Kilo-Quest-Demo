extends Node2D

@export var knife_scene: PackedScene
@export var throw_speed: float = 500.0
@export var max_speed: float = 800.0
@export var min_speed_ratio: float = 0.4

@export var min_line_length: float = 5.0
@export var max_line_length: float = 300.0

@export var line_width: float = 2.0
@export var max_line_width: float = 10.0

@export var flash_color: Color = Color(1, 0, 1, 1)
@export var flash_time: float = 0.2
@export var max_charge_time: float = 1.0
@export var line_texture: Texture2D

@export var aiming_line: Line2D
@export var cancel_delay_timer: Timer 

var current_knives : int = 4
var is_aiming: bool = false
var is_flashing: bool = false
var is_cancelled: bool = false
var direction: Vector2 = Vector2.ZERO
var charge_time: float = 0.0

@export var Audio : Node

var aiming_lock : bool = false
@export var unlock_aiming_timer : Timer

func _ready():
	SignalBus.connect('player_lock', _lock_aiming)
	SignalBus.connect('settings_lock', _lock_aiming)
	SignalBus.connect('break_player_lock', _unlock_aiming)
	SignalBus.connect('break_settings_lock', _unlock_aiming)
	SignalBus.connect("knife_gained", _on_knife_gained)

	aiming_line.clear_points()
	aiming_line.width = max_line_width
	aiming_line.modulate = Color(1, 1, 1, 1)

	if line_texture:
		aiming_line.texture = line_texture
		aiming_line.texture_mode = Line2D.LINE_TEXTURE_TILE
		aiming_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

	cancel_delay_timer.one_shot = true

func _process(delta: float) -> void:
	
	if aiming_lock == false : 
		var center = global_position

		# Get direction from KnifeSphere
		var knife_sphere = get_parent()
		direction = knife_sphere.direction.normalized()

		if is_cancelled:
			return


		# Aiming input
		if Input.is_action_pressed("attack") and not is_cancelled:
			is_aiming = true
			is_flashing = false
			charge_time = min(charge_time + delta, max_charge_time)
			display_line()


			if Input.is_action_just_pressed("secondary-action"):
				reset_aiming()
				SfxBus.emit_signal('kilo_cancel')

		elif Input.is_action_just_released("attack"):
			is_aiming = false
			is_flashing = true
			flash_dots()
			throw_knife()
			SfxBus.emit_signal('kilo_shoot')
			
	else:
		pass
		
func _lock_aiming():
	aiming_lock = true
	
func _unlock_aiming() : 
	unlock_aiming_timer.start()

func throw_knife():
	if not knife_scene or current_knives <= 0:
		return

	var charge_ratio = charge_time / max_charge_time
	var actual_speed = lerp(max_speed * min_speed_ratio, max_speed, charge_ratio)

	var knife_instance = knife_scene.instantiate()
	get_tree().get_root().add_child(knife_instance)
	knife_instance.global_position = global_position
	knife_instance.set("direction", direction)
	knife_instance.set("speed", actual_speed)

	SignalBus.emit_signal("knife_thrown")
	current_knives -= 1
	print("player:", current_knives)

	charge_time = 0.0
	is_cancelled = true
	cancel_delay_timer.start()

func _on_knife_gained():
	current_knives += 1

func display_line():
	if is_aiming:
		aiming_line.clear_points()
		aiming_line.modulate = Color(1, 1, 1, 1)

		var charge_ratio = charge_time / max_charge_time

		# Ensure the line starts from the aiming box's actual position
		var start_pos = global_position + (direction * 10)  # Offset start slightly outward

		# Extend outward based on aim direction and charge time
		var end_pos = start_pos + (direction * lerp(min_line_length, max_line_length, charge_ratio))

		# Convert to local space for Line2D
		aiming_line.add_point(aiming_line.to_local(start_pos))
		aiming_line.add_point(aiming_line.to_local(end_pos))

		aiming_line.width = lerp(max_line_width, line_width, charge_ratio)

func flash_dots():
	if is_flashing:
		var tween = create_tween()
		tween.tween_property(aiming_line, "width", max_line_width, flash_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(aiming_line, "modulate", flash_color, flash_time / 2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(aiming_line, "modulate", Color(1, 1, 1, 0), flash_time / 2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(aiming_line, "width", line_width, flash_time).set_delay(flash_time)
		tween.tween_callback(aiming_line.clear_points)

func reset_aiming():
	is_aiming = false
	is_flashing = false
	is_cancelled = true
	charge_time = 0.0

	aiming_line.clear_points()
	aiming_line.modulate = Color(1, 1, 1, 1)
	aiming_line.width = max_line_width

	cancel_delay_timer.start()

func _on_cancel_delay_timeout() -> void:
	is_cancelled = false


func _on_unlock_aiming_timer_timeout() -> void:
	aiming_lock = false
