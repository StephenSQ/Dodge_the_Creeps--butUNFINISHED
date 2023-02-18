extends Area2D


export var movement_speed = 100 #max = 500
export var angular_speed = 5 #max = 10
export var health = 100
var turn = 0 #for backward movement

func _ready():
	pass # Replace with function body.

func _process(delta):
	# TURNING MOVEMENT (LEFT RIGHT)
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction -= 1
	if Input.is_action_pressed("move_left"):
		direction += 1
	rotation += angular_speed * direction * delta
	
	#FORWARD BACKWARD MOVEMENT (BACKWARD MOVEMENT IN THE FORM OF TURNING 180 QUICKLY)
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity = Vector2.UP.rotated(rotation) * movement_speed
	elif Input.is_action_pressed("move_down"):
		if turn < PI: # ONLY turn if player hasn't turned for 180 degrees
			direction = angular_speed * 2 * delta # reused direction variable so that it will still trigger animation 
			rotation += direction
			turn += direction
	if Input.is_action_just_released("move_down"):
		turn = 0 # reset turn after down is released so the player can turn 180 again
	position += velocity * delta
	
	
	if velocity != Vector2.ZERO || direction != 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		$AnimatedSprite.frame = 0
