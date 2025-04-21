extends Node

var active_scene : String

signal load_demo()
signal load_menu()

func _ready() -> void:
	connect('load_demo', _on_load_demo)
	connect('load_menu', _on_load_menu)
	active_scene = 'menu'

# Called every frame. 'delta' is the elapsed time since the previous frame.
	
func _on_load_demo() :
	print('active scene = demo')
	active_scene = 'demo'
	
func _on_load_menu(): 
	print('active scene = menu')
	active_scene = 'menu'
