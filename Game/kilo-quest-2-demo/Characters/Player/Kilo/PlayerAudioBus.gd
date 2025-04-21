extends Node

@onready var walkPlayer = $walk
@onready var jumpPlayer = $jump
@onready var dashPlayer = $dash
@onready var cancelPlayer = $cancel
@onready var shootPlayer = $shoot
@onready var fallPlayer = $Fall
@onready var landPlayer = $land

var is_walking : bool = false
var is_falling : bool = false

signal play(sound)
signal stop_walk_signal()
signal shoot()


func _ready() -> void:
	SfxBus.connect('kilo_play', _on_kilo_play)
	SfxBus.connect('stop_walk_signal', _on_stop_walk)
	SfxBus.connect('kilo_shoot', _on_shoot)
	SfxBus.connect('kilo_cancel', _on_cancel)
	SfxBus.connect('stop_kilo_fall', _on_stop_fall)

func _on_stop_walk():
	walkPlayer.stop()
	is_walking = false
	
func _on_stop_fall():	
	print('stopping fall')
	fallPlayer.stop() 
	is_falling = false

	


func _on_kilo_play(sound):
	if sound == 'walk':
		if is_walking == true:
			pass
		else : 
			walkPlayer.play()
			is_walking = true
	elif  sound == 'jump':
		jumpPlayer.play()
	elif sound == 'dash':
		dashPlayer.play()
	elif sound == 'cancel' :
		cancelPlayer.play()
	elif sound == 'fall':
		if is_falling == true:
			print('fall player is already playing')
			pass
		elif is_falling == false:
			print('fall player should be playing')
			fallPlayer.play()
			is_falling = true
	elif sound == 'land':
		landPlayer.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_shoot():
	shootPlayer.play()
	
func _on_cancel():
	cancelPlayer.play()
	
func _on_check_kilo_walking() :
	if walkPlayer.playing == true:
		return true

func stop_fall():
	fallPlayer.stop()
