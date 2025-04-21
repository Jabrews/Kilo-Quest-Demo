extends Node

@export var level_theme : AudioStream
@onready var level_theme_player = $levelthemeplayer


func _ready() -> void:
		
	## play correct music volume on startup
	var loaded_music_volume = GameSettings.get_current_music_volume()
	var music_db = preform_db_calc(loaded_music_volume)
	level_theme_player.volume_db = music_db
	GameSettings.connect('change_music_volume', _on_change_music_volume)
	
	## play correct SFX volme on startup
	var loaded_sfx_volume = GameSettings.get_current_sfx_volume()
	var sfx_db = preform_db_calc(loaded_sfx_volume)
	for node in get_children():
		for audio in node.get_children():
			audio.volume_db = sfx_db	
	GameSettings.connect('change_sfx_volume', _on_change_sfx_volume)

	
	## play theme on startup
	level_theme_player.stream = level_theme
	level_theme_player.playing = true

func _on_change_music_volume(new_volume):
	var db = preform_db_calc(new_volume)
	level_theme_player.volume_db = db
	
## loop through all nodes, then their audio streamer children
func _on_change_sfx_volume(new_volume):
	var db = preform_db_calc(new_volume)
	for child in get_children():
		for audio in child.get_children():
			audio.volume_db = db
			
	
func preform_db_calc(volume):
	var percent = clamp(volume, 0, 100)
	var db = lerp(-35.0, 8.0, percent / 100.0)
	return db

## on sfx change _
	# get all nodes in self, if is type of node, get all children of type audio streamer and set accordingly.


func _on_levelthemeplayer_finished() -> void:
	level_theme_player.playing = true
