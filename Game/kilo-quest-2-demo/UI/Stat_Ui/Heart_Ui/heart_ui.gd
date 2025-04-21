extends HBoxContainer

@export var grace_period_timer: Timer
@export var player_hurt_streamer : AudioStreamPlayer2D

@onready var hearts := [
	$Heart1 as AnimatedSprite2D,
	$Heart2 as AnimatedSprite2D,
	$Heart3 as AnimatedSprite2D,
]

var max_hearts := 3
var current_health := 3
var in_grace := false

func _ready() -> void:
	SignalBus.connect("player_damaged", Callable(self, "_on_player_damaged"))
	SignalBus.connect('player_damaged_spike', _on_player_spike_damaged)

func _on_player_damaged():
		
	player_hurt_streamer.play()
	
	if in_grace:
		return
		
		
	in_grace = true
	grace_period_timer.start()

	current_health -= 1
	SignalBus.emit_signal('player_damage_flash')
	_update_hearts()
	
	if current_health == 0 :
		init_death('crumble')	

func _on_player_spike_damaged(type) :
	player_hurt_streamer.play()
	init_death('slash')	
	in_grace = true
	grace_period_timer.start()


func _update_hearts():
	for i in range(max_hearts):
		var heart = hearts[i]
		if i < current_health:
			heart.play("Full")
			heart.modulate = Color(1, 1, 1, 1)  # normal color & opacity
		else:
			heart.play("Empty")
			heart.modulate = Color(0.3, 0.3, 0.3, 0.5)  # darker and faded


func _on_grace_period_timer_timeout() -> void:
	SignalBus.emit_signal('player_damage_flash_stop')
	in_grace = false

func init_death(type): 
	if type == 'slash' : 
		SignalBus.emit_signal('player_death', 'slash')
	if type == 'crumble' :
		SignalBus.emit_signal('player_death', 'crumble')
