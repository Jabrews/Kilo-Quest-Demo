extends Node

var current_music_volume = 80.00
var current_sfx_volume = 50.00

signal change_music_volume(new_volume)
## signal that will be connected to music manager

## signal that will be connected to all sounds manager
signal change_sfx_volume(new_volume)




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect('change_music_volume', _on_change_music_volume)
	connect('change_sfx_volume', _on_change_sfx_volume)

func _on_change_music_volume(new_volume) : 
	print('MUSIC volume: ', new_volume)
	current_music_volume = new_volume
	
func _on_change_sfx_volume(new_volume) :
	print('SFX volume: ', new_volume)
	current_sfx_volume = new_volume

## getters

func get_current_music_volume():
	return current_music_volume
	
func get_current_sfx_volume():
	return current_sfx_volume
