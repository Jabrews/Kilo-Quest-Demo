extends CharacterBody2D

@export var mouse_active : bool = false
@export var move_speed : float = 300.0  # For arrow keys or gamepad input


var slider_lock : bool = false
var locked_y : float = 0.0


func _process(delta: float) -> void:
	
	if mouse_active : 

		var keyboard_input := Vector2.ZERO
		if Input.is_action_pressed("up"):
			keyboard_input.y -= 1
		if Input.is_action_pressed("down"):
			keyboard_input.y += 1
		if Input.is_action_pressed("left"):
			keyboard_input.x -= 1
		if Input.is_action_pressed("right"):
			keyboard_input.x += 1
		
		var gamepad_input := Vector2.ZERO
		gamepad_input.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		gamepad_input.y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		if gamepad_input.length() < 0.2:
			gamepad_input = Vector2.ZERO

		var input_vector = keyboard_input
		if input_vector == Vector2.ZERO:
			input_vector = gamepad_input
		
		if input_vector != Vector2.ZERO:
			position += input_vector.normalized() * move_speed * delta
		elif mouse_active:
			position = get_global_mouse_position()
		
