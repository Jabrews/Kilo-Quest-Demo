extends Node

@export var coinScene : PackedScene

func _ready() -> void:
	SignalBus.connect('spawn_coins', _on_spawn_coins)

func _on_spawn_coins(starting_pos, total_amount):
	var coins_array = create_array_of_coins(total_amount)
	create_coin_objects(coins_array, starting_pos)
	print(coins_array)

func create_array_of_coins(total_amount):
	# Validate the input: if total_amount is negative, log an error and return an empty array.
	if total_amount < 0:
		push_error("total_amount must be non-negative")
		return []
	
	# Calculate how many full coins of value 1 we can create.
	var full_coins = int(total_amount)
	var remainder = total_amount - full_coins
	
	# Create an empty array to hold our coin objects.
	var coins = []
	
	# Create full coins (each with an amount of 1) and alternate directions.
	for i in range(full_coins):
		var coin_data = {
			"amount": 1,
			"direction": "left" if i % 2 == 0 else "right",
			"type": "default"
		}
		coins.append(coin_data)
	
	# If there's a remainder, add it as a final coin. Its direction continues the alternation.
	if remainder > 0:
		var coin_data = {
			"amount": remainder,
			"direction": "left" if full_coins % 2 == 0 else "right",
			"type": "default"
		}
		coins.append(coin_data)
	
	return coins

func create_coin_objects(coins_array, starting_pos):
	#pass in starting_pos too
	for c in coins_array :
		var coin_instance = coinScene.instantiate()
		# Optionally, set properties on the instance (for example, its position).
		coin_instance.starting_pos = starting_pos
		coin_instance.amount = c.amount
		coin_instance.facing_direction = c.direction
		coin_instance.type = c.type
		# Add the coin instance as a child of the current node.
		add_child(coin_instance)
