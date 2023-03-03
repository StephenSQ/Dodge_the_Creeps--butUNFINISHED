extends Node
class_name StateMachine

onready var parent = get_parent()

var _current_state = null setget set_state
var _previous_state = null
var _state_dict = {}


# state machine logic is in here
func _physics_process(delta):
	if _current_state != null:
		_state_logic(delta)
		var transition = _get_transition(delta)
		if transition != null:
			set_state(transition)


# VIRTUAL FUNCTIONS to be defined inside another node's script.
# FUN FACT : virtual functions are named with a leading "_"

# To set how the parent will behave in it's current_state
func _state_logic(_delta) -> void:
	pass

# To set what states can the current state transition into
func _get_transition(_delta):
	return null

# To set what will happen everytime parent enters a new state
func _enter_state(_new_state, _old_state) -> void:
	pass

# To set what will happen everytime parent exits a state
func _exit_state(_old_state, _new_state) -> void:
	pass


func add_state(state_name) -> void: # to be used in _ready functions
	_state_dict[state_name] = _state_dict.size()

func set_state(new_state) -> void: # setting new states 
	_previous_state = _current_state
	_current_state = new_state
	
	if _previous_state != null:
		_exit_state(_previous_state, new_state)
	if new_state != null:
		_enter_state(new_state, _previous_state)
