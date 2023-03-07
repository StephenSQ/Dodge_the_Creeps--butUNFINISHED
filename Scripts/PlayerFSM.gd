extends StateMachine


func _ready():
	add_state("IDLE")
	add_state("MOVE")
	call_deferred("set_state", _state_dict.IDLE)

func _get_transition(_delta):
	match _current_state:
		_state_dict.IDLE:
			if parent.angular_velocity != 0.0:
				return _state_dict.MOVE
		_state_dict.MOVE:
			if parent.angular_velocity == 0.0:
				return _state_dict.IDLE
	
	print(parent.angular_velocity != 0.0)
	return null

func _enter_state(_new_state, _old_state) -> void:
	pass

func _exit_state(_old_state, _new_state) -> void:
	pass

func _state_logic(_delta) -> void:
	pass
	
