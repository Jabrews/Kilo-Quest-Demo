extends Node


func _ready():
	SignalBus.connect("character_damaged", Callable(self, "_on_character_health_changed"))

 
func _on_character_health_changed(body, damage) :
	if body.is_in_group('has_hit_state') :
		print('has hit state')
		var StateManager = body.get_node_or_null("StateManager")
		var HitNode = StateManager.get_node_or_null("Hit")
		if StateManager.current_state == HitNode :
			return
		body.health -= damage
		StateManager.change_state(HitNode)
