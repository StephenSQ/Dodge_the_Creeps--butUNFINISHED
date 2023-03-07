extends RigidBody2D

onready var animation_player := $AnimationPlayer
onready var body_sprite := $BodySprite
onready var attack_cd := $AttackCD


var player_level := 1 # max = 20 
var move_speed := 100 # max = 200
var turn_speed := 500 # max = 800
var max_health := 10 # max = 200
var health := max_health
var damage = 5
var cooldown_finished := true

export var turn_timing = 0.0 # to control turning in sync with AnimationPlayer
export var move_timing = 0.0 # to control movement in sync with AnimationPlayer

signal attack # the game will instance the player's attack
signal died # to inform the game that the player has died

func _ready() -> void:
	$HurtBox.collision_layer = 0 # so player's mines won't hurt the player

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
		apply_torque_impulse(direction * turn_speed * move_timing * delta)
	else:
		apply_torque_impulse(direction * turn_speed * turn_timing * delta)
	
	
	if velocity:
		animation_player.play("move_forward")
	else:
		if direction != 0:
			body_sprite.flip_h = direction > 0
			animation_player.play("turn")
		else:
			animation_player.stop()
			body_sprite.frame = 0


func _unhandled_input(event) -> void:
	if event.is_action_pressed("move_down") && cooldown_finished:
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
	else:
		return
