extends Control

@onready var settingsCam : Camera2D = $SettingsCamera
@export var playerMouse : CharacterBody2D

func  _ready() -> void:
	SignalBus.connect('exit_settings_menu', _on_exit_settings_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed('settings'):
		create_settings()
		
func create_settings() :
	settingsCam.enabled = true
	var settings_scene = preload('res://Levels/settings.tscn')
	var settings_instance = settings_scene.instantiate()
	settings_instance.scene_already_has_mouse = false
	SignalBus.emit_signal('switch_to_settings_camera')
	SignalBus.emit_signal('settings_lock')
	settings_instance.position = settingsCam.position
	playerMouse.mouse_active = true
	playerMouse.visible = true
	add_child(settings_instance)
	
func _on_exit_settings_menu():
	settingsCam.enabled = false
	SignalBus.emit_signal(('exit_from_settings_camera'))
	SignalBus.emit_signal('break_settings_lock')
	playerMouse.mouse_active = false
	playerMouse.visible = false
