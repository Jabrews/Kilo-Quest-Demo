extends Node

@onready var walkPlayer = $Walk
@onready var swordUpPlayer = $SwordUp
@onready var knight_attack = $Attack
@onready var knight_hit = $Hit
@onready var knight_death = $Death

var knight_walking : bool = false

func _ready() -> void:
	SfxBus.connect('knight_play', _on_knight_play)
	SfxBus.connect('stop_knight_walk', _on_stop_knight_walk)
	
func _on_knight_play(sound):
	if sound == 'walk':
		print('should be walking')
		walkPlayer.play()
		knight_walking = true
	if sound == 'attack':
		knight_attack.play()
	if sound == 'death':
		knight_death.play()
	if sound == 'sword-up':
		swordUpPlayer.play()
	if sound == 'hit':
		knight_hit.play()
		
func _on_stop_knight_walk():
	walkPlayer.stop()
	knight_walking = false


func _on_walk_finished() -> void:
	if knight_walking :
		walkPlayer.play()
