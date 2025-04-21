extends Node

@export var follow_camera : Camera2D
@export var room_camera : Camera2D
@export var death_camera : Camera2D
@export var Player : CharacterBody2D

# Screen shake variable
@export var shake_timer : Timer
var shake_strength = 30.0
var original_position = Vector2()
var is_shaking = false

var active_cam = null


# Synchronize camera positions when switching
func switchCamera(camera):
	# Get the current active camera and its position
	active_cam = follow_camera if follow_camera.enabled else room_camera
	var current_position : Vector2 = active_cam.position if active_cam else Vector2.ZERO
	
	if camera == 'follow':
		active_cam = follow_camera
		room_camera.enabled = false
		# Sync position from the currently active camera
		follow_camera.position = current_position
		follow_camera.enabled = true
	elif camera == 'room':
		active_cam = room_camera
		follow_camera.enabled = false
		# Sync position from the currently active camera
		room_camera.position = current_position
		room_camera.enabled = true
	elif camera == 'death':
		active_cam = death_camera
		follow_camera.enabled = false
		room_camera.enabled = false
		death_camera.enabled = true
		
func resetFollowCamera():
	follow_camera.drag_horizontal_enabled = false
	follow_camera.position_smoothing_enabled = false
	follow_camera.position_smoothing_speed = 5.0
	follow_camera.limit_bottom = 1000000
	follow_camera.limit_left = -1000000
	follow_camera.limit_right = 10000000
	follow_camera.limit_top = -1000000

# Function to smoothly transition the active camera's zoom (only used by Follow3 and Follow4 signals)
func transition_zoom(new_zoom: Vector2, duration: float = 0.5) -> void:
	# Get the currently active camera (follow_camera if enabled; otherwise, room_camera)
	if follow_camera.enabled :
		active_cam = follow_camera
	elif room_camera.enabled :
		active_cam = room_camera

	if active_cam:
		var tween = create_tween()
		tween.tween_property(active_cam, "zoom", new_zoom, duration) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN_OUT)

func _ready() -> void:
	
	active_cam = room_camera
	
	follow_camera.enabled = false
	room_camera.enabled = true
	room_camera.zoom = Vector2(1.8, 1.8)
	room_camera.limit_left = -310
	room_camera.limit_right = 375
	room_camera.limit_top = -60
	room_camera.limit_bottom = 300
	
	SignalBus.connect('screen_shake', _on_screen_shake)
	SignalBus.connect('player_death', _init_death_cam)
	SignalBus.connect('switch_to_settings_camera', _on_switch_to_settings_camera)
	SignalBus.connect('exit_from_settings_camera', _on_exit_from_settings_camera)
	
func _on_switch_to_settings_camera():
	active_cam.enabled = false
	print(active_cam)
	print(' SWITCH active_cam.enabled: ', active_cam.enabled )
	
func _on_exit_from_settings_camera():
	active_cam.enabled = true
	print(active_cam)
	print(' EX active_cam.enabled: ', active_cam.enabled )


	
func _on_follow_1_body_entered(body: Node2D) -> void:
	switchCamera('follow')
	resetFollowCamera()
	# Set zoom directly without tween
	follow_camera.zoom = Vector2(2.5, 2.5)
	follow_camera.limit_left = 350
	follow_camera.limit_right = 850
	follow_camera.limit_top = 60
	follow_camera.limit_bottom = 760
	follow_camera.position_smoothing_enabled = true
	follow_camera.drag_horizontal_enabled = true

func _on_room_0_body_entered(body: Node2D) -> void:
	switchCamera('room')
	# Set zoom directly without tween
	room_camera.zoom = Vector2(1.8, 1.8)
	room_camera.limit_left = -310
	room_camera.limit_right = 375
	room_camera.limit_top = -60
	room_camera.limit_bottom = 300
	room_camera.drag_horizontal_enabled = false
	room_camera.drag_vertical_enabled = false

func _on_room_1_body_entered(body: Node2D) -> void:
	resetFollowCamera()
	switchCamera('follow')
	# Set zoom directly without tween
	follow_camera.zoom = Vector2(1.5, 1.5)
	follow_camera.limit_left = -310
	follow_camera.limit_right = 525 
	follow_camera.limit_top = 310
	follow_camera.limit_bottom = 800
	follow_camera.drag_horizontal_enabled = true
	follow_camera.position_smoothing_enabled = true
	follow_camera.position_smoothing_speed = 3.0
	
func _on_screen_shake():
	# Get the active camera (the one that is enabled)
	var active_cam : Camera2D = follow_camera if follow_camera.enabled else room_camera
	if active_cam:
		# Store the original position
		original_position = active_cam.position
		is_shaking = true
		# Start the timer for the shake duration (e.g., 0.3 seconds)
		shake_timer.start(0.3)

func _process(delta: float) -> void:
	# While shaking, add a random offset to the active camera's position
	if is_shaking:
		var active_cam : Camera2D = follow_camera if follow_camera.enabled else room_camera
		if active_cam:
			active_cam.position = original_position + Vector2(
				randf_range(-shake_strength, shake_strength),
				randf_range(-shake_strength, shake_strength)
			)

func _on_shake_length_timeout() -> void:
	# When the timer finishes, reset the active camera's position
	var active_cam : Camera2D = follow_camera if follow_camera.enabled else room_camera
	if active_cam:
		active_cam.position = original_position
	is_shaking = false

# These two signals now use the smooth zoom transition effect
func _on_follow_3_body_entered(body: Node2D) -> void:
	switchCamera('follow')
	resetFollowCamera()
	transition_zoom(Vector2(1.5, 1.5), 0.1)
	follow_camera.limit_bottom = 760
	follow_camera.limit_left = -2075
	follow_camera.position_smoothing_enabled = true
	follow_camera.drag_horizontal_enabled = true

func _on_follow_4_body_entered(body: Node2D) -> void:
	switchCamera('follow')
	resetFollowCamera()
	transition_zoom(Vector2(2.0, 2.0), 0.1)
	follow_camera.limit_bottom = 760
	follow_camera.position_smoothing_enabled = true
	follow_camera.drag_horizontal_enabled = true
	
func _init_death_cam(type):
	switchCamera("death")
	# Start with the active camera's zoom
	death_camera.zoom = active_cam.zoom
	death_camera.global_position = Player.global_position

	# Create a tween to animate the zoom from the current value to (4, 4) over 1 second.
	var tween = create_tween()
	tween.tween_property(death_camera, "zoom", Vector2(4, 4), 0.5)
