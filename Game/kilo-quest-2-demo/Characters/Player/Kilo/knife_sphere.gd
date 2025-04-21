extends Node2D

@export var radius: float = 25.0
@export var dead_zone_radius: float = 5.0
@export var controller_sensitivity: float = 1000.0
@export var max_aim_distance: float = 200.0

# Knife throw visuals
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

@export var aiming_box: Node2D
@export var aiming_line: Line2D 
@export var cancel_delay_timer: Timer 
@export var line_start_offset: float = 30.0

var aim_offset: Vector2 = Vector2.RIGHT * 100
var direction: Vector2 = Vector2.RIGHT
var last_mouse_pos: Vector2 = Vector2.ZERO
var using_controller: bool = false

# Knife throw state
var current_knives: int = 4
var is_aiming: bool = false
var is_flashing: bool = false
var is_cancelled: bool = false
var charge_time: float = 0.0

const STICK_DEADZONE := 0.2

func _ready():
	SignalBus.connect("knife_gained", _on_knife_gained)
	aim_offset = Vector2.RIGHT * 100

	aiming_line.clear_points()
	aiming_line.width = max_line_width
	aiming_line.modulate = Color(1, 1, 1, 1)
	if line_texture:
		aiming_line.texture = line_texture
		aiming_line.texture_mode = Line2D.LINE_TEXTURE_TILE
		aiming_line.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED

func _input(event):
	if event is InputEventMouseMotion:
		# Don’t switch instantly; handled in _process
		pass

func _process(delta):
	
	aiming_box.position = aim_offset

	
	var center := global_position

	# --- Aiming Input with deadzone and input switch handling ---
	var raw_stick := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)

	var stick_magnitude := raw_stick.length()
	if stick_magnitude > STICK_DEADZONE:
		if not using_controller:
			print("Switched to controller")
		using_controller = true

		# Smooth scaling
		var scaled_strength := (stick_magnitude - STICK_DEADZONE) / (1.0 - STICK_DEADZONE)
		var adjusted_stick := raw_stick.normalized() * scaled_strength

		aim_offset += adjusted_stick * controller_sensitivity * delta
		if aim_offset.length() > max_aim_distance:
			aim_offset = aim_offset.normalized() * max_aim_distance

	else:
		var mouse_pos = get_global_mouse_position()
		var mouse_movement := (mouse_pos - last_mouse_pos).length()
		if mouse_movement > 10.0 and not using_controller:
			print("Switched to mouse")
			aim_offset = mouse_pos - center
			using_controller = false
		last_mouse_pos = mouse_pos

	# --- Direction ---
	if aim_offset.length() > dead_zone_radius:
		direction = aim_offset.normalized()

	# --- Aiming box position ---
	aiming_box.position = direction * radius

	# --- Throwing logic ---
	if is_cancelled:
		return

	if Input.is_action_pressed("attack") and not is_cancelled:
		is_aiming = true
		is_flashing = false
		charge_time = min(charge_time + delta, max_charge_time)
		display_line()

		if Input.is_action_just_pressed("secondary-action"):
			reset_aiming()

	elif Input.is_action_just_released("attack"):
		is_aiming = false
		is_flashing = true
		flash_dots()
		throw_knife()

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
	SfxBus.emit_signal("knife_start")
	current_knives -= 1

	charge_time = 0.0
	is_cancelled = true
	cancel_delay_timer.start()

func _on_knife_gained():
	current_knives += 1
	
	
func display_line():
	if is_aiming:
		aiming_line.clear_points()
		aiming_line.modulate = Color(1, 1, 1, 1)

		var width: float = lerp(max_line_width, line_width, charge_time / max_charge_time)

		# Start position: Offset from player in the aiming direction
		var start_pos = global_position + (direction * line_start_offset)

		# End position: Extending outward in the aiming direction
		var end_pos = start_pos + (direction * max_aim_distance)

		# Apply points to Line2D in **local space**
		aiming_line.add_point(aiming_line.to_local(start_pos))
		aiming_line.add_point(aiming_line.to_local(end_pos))
		aiming_line.width = width


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

func _on_cancel_delay_timeout():
	is_cancelled = false
