extends Node

@export var Razor1 : Area2D
@export var Razor2 : Area2D
@export var Razor3 : Area2D



func _on_moving_razor_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.emit_signal("player_damaged_spike", "slash")

func _on_moving_razor_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.emit_signal("player_damaged_spike", "slash")

func _on_moving_razor_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SignalBus.emit_signal("player_damaged_spike", "slash")
