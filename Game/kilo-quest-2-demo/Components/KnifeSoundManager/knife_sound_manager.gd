extends Node

@onready var knife_start = $Knife_Start
@onready var knife_end = $Knife_End

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SfxBus.connect("knife_end", _on_knife_end)
	SfxBus.connect("knife_start", _on_knife_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_knife_end():
	knife_end.play()
	
func _on_knife_start():
	knife_start.play()
