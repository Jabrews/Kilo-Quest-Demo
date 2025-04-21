extends Control

var loaded_scene: PackedScene = null
var load_thread: Thread = Thread.new()

var active_scene

func _ready() -> void:
	active_scene = Router.active_scene
	# Immediately start loading based on the active_scene value.
	load_scene()

func load_scene() -> void:
	var load_callable
	if active_scene == "menu":
		print("Active scene is menu. Loading menu scene.")
		load_callable = Callable(self, "_load_scene_thread").bind("res://Levels/menu.tscn")
	if active_scene == 'demo':
		print("Active scene is not menu. Loading demo level.")
		load_callable = Callable(self, "_load_scene_thread").bind("res://Levels/demo_level.tscn")
	load_thread.start(load_callable)
	

func _load_scene_thread(path: String) -> void:
	print("Thread started: loading scene from ", path)
	loaded_scene = load(path)
	print("Thread finished: scene loaded -> ", loaded_scene)

func _process(delta: float) -> void:
	if loaded_scene:
		print("Scene loaded! Changing scene now...")
		get_tree().change_scene_to_packed(loaded_scene)
		# Clean up the thread for future use.
		load_thread.wait_to_finish()
		load_thread = Thread.new()
		loaded_scene = null
