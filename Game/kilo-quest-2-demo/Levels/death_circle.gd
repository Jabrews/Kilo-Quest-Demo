extends Control

@export var Sprite: Sprite2D
@export var DeathCam: Camera2D
@export var SwitchToScreenTimer : Timer

func _ready() -> void:
	Sprite.visible = false
	SignalBus.connect("player_death", _on_player_death)

func _on_player_death(type):
	print('death circle!!!')
	Sprite.visible = true
	SwitchToScreenTimer.start()


func _on_switch_to_death_screen_timeout() -> void:
	SignalBus.emit_signal('fade_to_black')
