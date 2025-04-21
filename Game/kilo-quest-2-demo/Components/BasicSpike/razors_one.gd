extends Node

func _on_razor_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		SignalBus.emit_signal('player_damaged')


func _on_razor_2_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		SignalBus.emit_signal('player_damaged')

func _on_razor_3_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		SignalBus.emit_signal('player_damaged')

func _on_razor_4_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		SignalBus.emit_signal('player_damaged')

func _on_razor_5_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		SignalBus.emit_signal('player_damaged')
