extends Control

var scene_already_has_mouse : bool = true
var mouse_loop_completed : bool = false
var quit_hover : bool = false

# Checkbox variables
var fullscreen_checkbox_hover : bool = false
var is_fullscreen : bool = false
@export var fullscreen_checkbox_sprite : AnimatedSprite2D

var windowed_checkbox_hover : bool = false
var is_windowed : bool = false
@export var windowed_checkbox_sprite : AnimatedSprite2D

# Music Slider (for settings)
@export var music_slider : HSlider
@export var sfx_slider : HSlider

func _ready() -> void:
	music_slider.value = GameSettings.get_current_music_volume()
	sfx_slider.value = GameSettings.get_current_sfx_volume()
	# Set default window mode.
	is_windowed = true
	is_fullscreen = false
	windowed_checkbox_sprite.play("checked")
	fullscreen_checkbox_sprite.play("unchecked")
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _process(delta: float) -> void:
	# Close settings when needed.
	if quit_hover and Input.is_action_just_pressed("attack"):
		SignalBus.emit_signal("exit_settings_menu")
		self.queue_free()
		
	# Fullscreen checkbox logic:
	if fullscreen_checkbox_hover and Input.is_action_just_pressed("attack"):
		if not is_fullscreen:
			is_fullscreen = true
			is_windowed = false
			fullscreen_checkbox_sprite.play("checked")
			windowed_checkbox_sprite.play("unchecked")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
			
			
	# Windowed checkbox logic:
	if windowed_checkbox_hover and Input.is_action_just_pressed("attack"):
		if not is_windowed:
			is_windowed = true
			is_fullscreen = false
			windowed_checkbox_sprite.play("checked")
			fullscreen_checkbox_sprite.play("unchecked")
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
	
### Close Settings ###
func _on_close_icon_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		quit_hover = true

func _on_close_icon_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		quit_hover = false

### FULLSCREEN CHECKBOX ###
func _on_full_screen_checkbox_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		fullscreen_checkbox_hover = true
		fullscreen_checkbox_sprite.scale = scale.lerp(Vector2(2, 2), 0.1)

func _on_full_screen_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): 
		fullscreen_checkbox_hover = false
		fullscreen_checkbox_sprite.scale = scale.lerp(Vector2(1, 1), 0.1)

### WINDOWED CHECKBOX ###
func _on_windowed_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): 
		windowed_checkbox_hover = true
		windowed_checkbox_sprite.scale = scale.lerp(Vector2(2, 2), 0.1)

func _on_windowed_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"): 
		windowed_checkbox_hover = false
		windowed_checkbox_sprite.scale = scale.lerp(Vector2(1, 1), 0.1)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	GameSettings.emit_signal('change_music_volume', music_slider.value)


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	GameSettings.emit_signal('change_sfx_volume', sfx_slider.value)
