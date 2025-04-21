extends Node

@onready var CoinCollect = $CoinCollect
@onready var ChestOpened = $ChestOpen


func _ready() : 
	SfxBus.connect('coin_collected', _on_coin_collected)
	SfxBus.connect('chest_open', _on_chest_open)


func _on_coin_collected(): 
	CoinCollect.play()
	
	
func _on_chest_open():
	ChestOpened.play()
