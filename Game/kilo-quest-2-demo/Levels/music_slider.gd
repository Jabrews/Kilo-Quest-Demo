extends HSlider

func _gui_input(event):
	if event is InputEventMouse:
		print("Slider got mouse input:", event)
