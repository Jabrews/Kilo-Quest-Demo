extends CharacterBody2D

# Player Components
@export var Sprite: AnimatedSprite2D
@export var Dash_Timer: Timer
@export var DashGhostScene: PackedScene
@export var Audio: Node

# Movement settings
@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -100.0

var can_double_jump: bool = false
var was_in_air: bool = false
var direction: Vector2 = Vector2.ZERO

# Animation Vars
var animation_lock: bool = false

# Dash Vars
var can_dash: bool = true
@export var dash_speed: int = 20
var is_dashing: bool = false

# Freeze Time 
@export var freeze_time_timer: Timer
var stored_original_color: Color

# Dash Time
@export var flash_time: Timer
var sprite_visible: bool = true
@export var dash_cooldown_timer: Timer

# Death
var movement_lock : bool = false
var settings_lock : bool = false


var has_jumped: bool = false
var land_sound_played : bool = false


func _ready() -> void:
	SignalBus.connect('player_damage_flash', _player_sprite_flash)
	SignalBus.connect('player_damage_flash_stop', _stop_player_sprite_flash)
	SignalBus.connect('player_death', _on_player_death)
	SignalBus.connect('player_lock', _on_player_lock)
	SignalBus.connect('break_player_lock', _on_break_player_lock)
	SignalBus.connect('settings_lock', _on_settings_lock)
	SignalBus.connect('break_settings_lock', _on_break_settings_lock)

func _physics_process(delta: float) -> void:
	if settings_lock == true:
		velocity = Vector2.ZERO
	elif movement_lock == false:
		
		#if was_in_air == true and is_on_floor():
			#SfxBus.emit_signal('stop_kilo_fall')
			#SfxBus.emit_signal('kilo_play', 'land')
			


	
		
		# Reset dash only when on the floor and the dash cooldown timer has finished.
		if is_on_floor() and dash_cooldown_timer.is_stopped():
			can_dash = true

		# Start dash if conditions met
		if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
			dash_cooldown_timer.start()
			can_dash = false
			dash()

		if is_dashing:
			move_and_slide()
			return

		# Gravity & Jumping
		if not is_on_floor():
			land_sound_played = false
			SfxBus.emit_signal('kilo_play', 'fall')
			velocity += get_gravity() * delta
			if not was_in_air and not is_dashing and not animation_lock:
				animationManager("jump_air")
				SfxBus.emit_signal('stop_walk_signal')
			was_in_air = true
		else:
			if was_in_air:
				animationManager("jump_land")
				SfxBus.emit_signal('kilo_play', 'land')
				if land_sound_played == false:
					SfxBus.emit_signal('kilo_play', 'land')
					land_sound_played = true
					
			can_double_jump = false
			was_in_air = false

		if Input.is_action_just_pressed("up"):
			if is_on_floor():
				jump()
				has_jumped = true  # Set jumped state
			elif can_double_jump:
				velocity.y = double_jump_velocity
				SfxBus.emit_signal("kilo_play", "jump")
				can_double_jump = false

		# Movement
		if not is_dashing:
			direction = Input.get_vector("left", "right", "up", "down")
			velocity.x = direction.x * speed if direction.x else move_toward(velocity.x, 0, speed)

		if is_on_floor() and not is_dashing and not animation_lock:
			if direction.x != 0:
				animationManager("run")
				SfxBus.emit_signal("kilo_play", "walk")		
			else:
				SfxBus.emit_signal("stop_walk_signal")
				animationManager("idle")

		horizontalAnimationManager(direction)
		move_and_slide()
		
	else :
		velocity = Vector2.ZERO
		if not is_on_floor():
			velocity +=  Vector2(0, 5000) * delta
		move_and_slide()

	if is_on_floor() :
		print('stopping fall because on ground')
		SfxBus.emit_signal('stop_kilo_fall')
			
	if !is_on_floor() and !is_dashing:
		if is_falling():
			SfxBus.emit_signal('kilo_play', 'fall')

func is_falling():
	if velocity.y > 0 :
		print('this y velocity is more than 0: ', velocity.y)
		return true
		

func jump():
	SfxBus.emit_signal("stop_walk_signal")
	SfxBus.emit_signal("kilo_play", "jump")
	animationManager("jump_start")
	velocity.y = jump_velocity
	can_double_jump = true

func dash():
	SfxBus.emit_signal("kilo_play", "dash")
	is_dashing = true

	spawn_dash_ghosts()  # Spawns multiple ghosts

	var Aiming_Box = get_node('KnifeSphere/AimingBox')
	var dash_direction = Aiming_Box.direction.normalized()
	animationManager('dash_start')
	velocity = dash_direction * dash_speed
	Dash_Timer.start()

func spawn_dash_ghosts():
	var ghost_count := 5
	var delay := 0.03  # Time between each ghost

	for i in ghost_count:
		var ghost = DashGhostScene.instantiate()
		ghost.placement_pos = global_position
		ghost.face_left = direction.x < 0
		get_tree().current_scene.add_child(ghost)
		await get_tree().create_timer(delay).timeout

func horizontalAnimationManager(direction) -> void:
	if direction.x < 0:
		Sprite.flip_h = true
	elif direction.x > 0:
		Sprite.flip_h = false

func animationManager(anim: String) -> void:
	if animation_lock and anim not in ["jump_land", "dash", "dash_start"]:
		return

	if anim == "run":
		Sprite.play("run")
	elif anim == "idle":
		Sprite.play("idle")
	elif anim == "jump_start":
		animation_lock = true
		Sprite.play("jump_start")
	elif anim == "jump_air":
		Sprite.play("jump_air")
	elif anim == "jump_land" and is_on_floor():
		Sprite.play("jump_land")
		animation_lock = false
	elif anim == "dash_start":
		Sprite.play("dash_start")
		animation_lock = true
	elif anim == "dash":
		Sprite.play("dash")
		animation_lock = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if Sprite.animation == "jump_start":
		animation_lock = false
		animationManager("jump_air")
	elif Sprite.animation == "jump_land":
		animation_lock = false
	elif Sprite.animation == "dash_start":
		animationManager("dash")

func _player_sprite_flash() -> void:
	if Sprite == null:
		print("Sprite reference is missing!")
		return
	stored_original_color = Sprite.self_modulate
	Engine.time_scale = 0.001
	Sprite.self_modulate = Color(1, 0, 0, 1)
	freeze_time_timer.start()

func _on_freeze_time_timeout() -> void:
	Sprite.self_modulate = stored_original_color
	Engine.time_scale = 1.0
	flash_time.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false
	velocity = Vector2.ZERO

func _on_dash_cooldown_timeout() -> void:
	if is_on_floor():
		can_dash = true

func _stop_player_sprite_flash():
	flash_time.stop()
	sprite_visible = true
	Sprite.visible = true

func _on_flash_time_timeout() -> void:
	sprite_visible = !sprite_visible
	Sprite.visible = sprite_visible
	
func _on_player_death(type):
	flash_time.stop()
	movement_lock = true
	if type == 'slash':
		Sprite.play('slash_death')
		await Sprite.animation_finished
		Sprite.play('slash-death-idle')
	elif type == 'crumble':
		Sprite.play('crumble_death')
		await Sprite.animation_finished
		Sprite.play('crumble-death-idle')

func _on_player_lock():
	movement_lock = true
	set_collision_layer_value(2, false)

func _on_break_player_lock():
	movement_lock = false
	set_collision_layer_value(2, true)

func _on_settings_lock():
	print('enter settings lock')
	settings_lock = true
	set_collision_layer_value(2, false)

func _on_break_settings_lock():
	print('break settings lock')
	settings_lock = false
	set_collision_layer_value(2, true)
