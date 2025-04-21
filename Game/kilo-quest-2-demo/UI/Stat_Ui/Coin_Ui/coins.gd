extends HBoxContainer

@export var label: Label

# Starting coin amount
var coin_amount: float = 0.0

func _ready() -> void:
	# Set initial label text.
	label.text = "$0.0"
	# Connect the coin_got signal.
	SignalBus.connect("coin_got", _on_coin_got)

func _on_coin_got(amount):
	# Increase the coin amount by the provided value.
	coin_amount += amount
	# Update the label's text formatted to one decimal place.
	label.text = "$%.1f" % coin_amount
