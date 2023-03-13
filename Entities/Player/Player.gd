extends RigidBody2D

onready var main_animation := $MainAnimations
onready var second_animation := $SecondaryAnimations
onready var body_sprite := $BodySprite
onready var eye_sprite := $EyeBall
onready var attack_cd := $AttackCD


# STATS VARIABLES
var player_level := 1 # max = 20 
var move_speed := 10000 # max = 20000, playback_speed = 3
var turn_speed := 25000 # max = 35000
var max_health := 10 # max = 200
var damage = 5

var health := max_health
var eye_target = null
var cooldown_finished := true
export var move_timing = 0.0 # to control movement in sync with AnimationPlayer

signal attack # the game will instance the player's attack
signal entered_sight # alert camera that something enter's the player's sight
signal exited_sight # alert camera that something left the player's sight
signal died # to inform the game that the player has died

func _ready() -> void:
	$HurtBox.collision_layer = 0 # so player's mines won't hurt the player
	set_physics_process(false)
	main_animation.play("spawn")

func _physics_process(delta) -> void:
	# TURNING MOVEMENT
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction -= 1
	if Input.is_action_pressed("move_left"):
		direction += 1
	
	# FORWARD BACKWARD MOVEMENT
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity = Vector2.UP.rotated(rotation) * move_speed
		apply_central_impulse(velocity * move_timing * delta)
		apply_torque_impulse(direction * turn_speed * delta)
	else:
		apply_torque_impulse(direction * turn_speed * delta)
	
	
	if velocity:
		main_animation.play("move_forward")
	else:
		if direction != 0:
			body_sprite.flip_h = direction > 0
			main_animation.play("turn")
		else:
			main_animation.stop()
			body_sprite.frame = 4
	if eye_target:
		eye_sprite.rotation = (eye_target.position - position).angle() + (PI / 2) - rotation
	else:
		eye_sprite.rotation = lerp_angle(eye_sprite.rotation, 0, 0.05)


func _unhandled_input(event) -> void:
	if event.is_action_pressed("attack_spacebar") && cooldown_finished:
		emit_signal("attack", damage)
		attack_cd.start()
		cooldown_finished = false
# SIGNAL RECEIVER CODE REFERENCE
#func _on_Player_attack(damage) -> void:
#	var player_mine = CytolyticCell_scene.instance()
#	player_mine.position = $Player.position
#	player_mine.get_node("HitBox").damage = damage
#	add_child(player_mine)

func _on_AttackCooldown_timeout() -> void:
	cooldown_finished = true


func take_damage(amount: int) -> void:
	health -= amount
	print(health)
	if health < 1:
		emit_signal("died")
#	else:
#		return
	second_animation.play("blink_hurt")


func _on_SightRange_body_entered(target: RigidBody2D):
	if not target:
		return
	
	emit_signal("entered_sight", target)
	eye_target = target
	print("entered sight")


func _on_SightRange_body_exited(target: RigidBody2D):
	if target == eye_target:
		eye_target = null
	emit_signal("exited_sight", target)
