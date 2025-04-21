extends Control

signal create_settings_instance()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect('create_settings_instance', _on_create_settings_instance)


func _on_create_settings_instance():
	var settings_scene = preload('res://Levels/settings.tscn')
	var settings_instance = settings_scene.instantiate()
	add_child(settings_instance)
