extends Node


signal character_damaged(body, damage)
signal player_damaged()
signal player_damaged_spike(type)
signal player_damage_flash()
signal player_damage_flash_stop()
signal player_death(type)
signal knife_thrown()
signal total_knives()
signal knife_gained()
signal player_lock()
signal break_player_lock()

## Sound manager ##



#coins + treasure chest
signal spawn_coins(starting_pos, total_amount)
signal coin_got(amount)


#camera 
signal screen_shake()
signal fade_to_black()

#settings 
signal switch_to_settings_camera()
signal exit_from_settings_camera()
signal exit_settings_menu()
signal settings_lock()
signal break_settings_lock()

#mouse
signal mouse_slider_enter(point)
signal mouse_slider_exit(point)
