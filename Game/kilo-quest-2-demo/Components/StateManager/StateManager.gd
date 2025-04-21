extends Node

# This script defines a StateManager class that handles switching between different states.
class_name StateManager

@onready var IdleState = $Idle

# The current active state
@export var current_state: State = null  # Start with no state assigned

# Get components
@export var Character : CharacterBody2D

func _ready():
	# Ensure we start in the Idle state and run its enter function
	if IdleState:
		current_state = IdleState
		current_state.enter()  # Manually trigger enter on boot


# Called every frame
func _process(delta):
	if current_state:
		# Calls the update function of the current state if it exists
		current_state.update(delta)


# Function to change the current state
func change_state(new_state: State):
	if current_state:
		# Calls exit() on the current state before switching (if it exists)
		current_state.exit()
	
	# Switch to the new state
	current_state = new_state
	
	if current_state:
		# Calls enter() on the new state (if it exists)
		current_state.enter()
