extends RigidBody2D

var player_level := 1 # max = 20 
var movement_speed := 100 # max = 200
var turning_speed := 500 # max = 800
var health := 100 # max = 200

export var turn_timing = 0.0 # to control turning in sync with AnimationPlayer
export var move_timing = 0.0 # to control movement in sync with AnimationPlayer
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	# TURNING MOVEMENT
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction -= 1
	if Input.is_action_pressed("move_left"):
		direction += 1
	
	# FORWARD BACKWARD MOVEMENT
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity = Vector2.UP.rotated(rotation) * movement_speed
		apply_central_impulse(velocity * move_timing * delta)
		apply_torque_impulse(direction * turning_speed * move_timing * delta)
	else:
		apply_torque_impulse(direction * turning_speed * turn_timing * delta)
	
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity:
		$AnimationPlayer.play("move_forward")
	else:
		if direction != 0:
			$BodySprite.flip_h = direction > 0
			$AnimationPlayer.play("turn")
		else:
			$AnimationPlayer.stop()
			$BodySprite.frame = 0
