extends Node

@onready var agroPlayer = $Agro
@onready var deathRattlePlayer = $Death_Rattle
@onready var fallPlayer = $Fall
@onready var shootEndPlayer = $Shoot_end
@onready var shootStartPlayer = $Shoot_start


func _ready() -> void:
	SfxBus.connect("eyeball_play", _on_eyball_play)

func _on_eyball_play(sound):
	if sound == 'agro':
		agroPlayer.play()
	if sound == 'shoot_start':
		shootStartPlayer.play()
	if sound == 'sound_end':
		shootEndPlayer.play()
	if sound == 'fall':
		fallPlayer.play()
	if sound == 'stop_fall':
		fallPlayer.stop()
	if sound == 'death_rattle':
		deathRattlePlayer.play()
