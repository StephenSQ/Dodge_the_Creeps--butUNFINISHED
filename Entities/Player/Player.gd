extends RigidBody2D

# ONREADY VARIABLES
onready var main_animation := $MainAnimations
onready var expressions # for animation tree statemachine
onready var body_sprite := $BodySprite
onready var eyelid_reset = $SecondaryAnimations.get_animation("RESET")
onready var eye_sprite := $EyeBall
onready var attack_cd := $AttackCD

# STATS VARIABLES
var max_level := 1 # note: using update_stats you can play with every lvl stats
var move_speed := 5000.0 # max = 10000, playback_speed = 3
var turn_speed := 2000.0 # max = 4000
var max_health := 10.0 # max = 200
var max_ammo := 3 # max = 15
var damage := 3.0 # max = 38


var health : float
var ammo : int
var eye_target = null
export var cooldown_finished := false
export var move_timing = 0.0 # to control movement in sync with AnimationPlayer

# SIGNALS
signal attack # the game will instance the player's attack
signal hit # alert gameworld player got hit
signal entered_sight # alert camera that something enter's the player's sight
signal exited_sight # alert camera that something left the player's sight
signal died # to inform the game that the player has died


func _ready() -> void:
	expressions = $ExpressionAnimTree.get("parameters/playback")
	$ExpressionAnimTree.active = true # activate animation tree on ready
	$HurtBox.collision_layer = 0 # so player won't trigger its mines
	update_stats(max_level) # to set stats to its set max_level
	set_physics_process(false) # be set to true on spawn animation
	set_process_unhandled_input(false) # be set to true on spawn animation

# MOVEMENT IN _PHYSICS_PROCESS()
func _physics_process(delta) -> void:
	# TURNING MOVEMENT
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction -= 1
	if Input.is_action_pressed("move_left"):
		direction += 1	
	apply_torque_impulse(direction * turn_speed * delta)
	
	# FORWARD MOVEMENT
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity = Vector2.UP.rotated(rotation) * move_speed
		apply_central_impulse(velocity * move_timing * delta)
	
	# ANIMATIONS
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
	elif eye_sprite.rotation: # if there's nothing in sight and eye hasn't faced forward
		eye_sprite.rotation = lerp_angle(eye_sprite.rotation, 0, 0.05) # move eye to face forward


# PLAYER ATTACK
func _unhandled_input(event) -> void:
	if event.is_action_pressed("attack_spacebar"):
		if cooldown_finished && ammo:
			emit_signal("attack", damage, self)
			attack_cd.start()
			cooldown_finished = false
			ammo -= 1
			expressions.travel("blink_attack")
		else:
			expressions.travel("blink")
# SIGNAL RECEIVER CODE REFERENCE
#func _on_Player_attack(damage, player) -> void:
#	var player_mine = CytolyticCell_scene.instance()
#	player_mine.position = player.position
#	player_mine.get_node("HitBox").damage = damage
#	add_child(player_mine)
func _on_AttackCooldown_timeout() -> void:
	cooldown_finished = true


# PLAYER TAKE DAMAGE: FUNCTION CALLED BY HURTBOX
func take_damage(amount: float) -> void:
	health -= amount
	print(health)
	if health < 1:
		emit_signal("died", self)
		expressions.travel("die")
		return
	elif health < max_health / 2.0:
		eyelid_reset.track_set_key_value(2, 0, 5)
		eyelid_reset.track_set_key_value(3, 0, Color(1.0, 0.8, 0.9))
	else:
		eyelid_reset.track_set_key_value(2, 0, 0)
		eyelid_reset.track_set_key_value(3, 0, Color(1.0, 1.0, 1.0))
	emit_signal("hit")
	expressions.travel("blink_hurt")

# PLAYER HEAL
func heal(amount: float) -> void:
	health = min(health + amount, max_health)

# PLAYER RELOAD
func reload(amount: int) -> void:
# warning-ignore:narrowing_conversion
	ammo = min(ammo + amount, max_ammo)


# TO UPDATE AND UPGRADE PLAYER STATS
func update_stats(lvl: int) -> void:
	if lvl > max_level || lvl < 1:
		return
	
	max_health = lvl * 10						# 10, 20, 30, ... max = 200
	max_ammo = 3 + int(floor((lvl - 1.0) / 1.5))	# 3, 3, 4, ... max = 15
	damage = lvl * 3							# 3, 6, 9, ... max = 60
	attack_cd.wait_time = 2.97 - ((lvl - 1.0) * 0.13)	# 2.97, 2.84, max = 0.5 s
	
	turn_speed = 2000.0 + ceil((lvl - 1.0) * 105.26)	# 2000, 2106, ... max = 4000
	angular_damp = stepify(5 + ((lvl - 1.0) * 0.15), 0.15)		# 6.1, 6.2, ... max = 8
	
	main_animation.playback_speed = stepify(2.0 + ((lvl - 1.0) * 0.052), 0.1) # max = 3
	move_speed = 5000.0 + ceil((lvl - 1.0) * 157.89) # 5000, 5158, ... max = 8000
	
	
	health = max_health
	ammo = max_ammo

func upgrade(lvl: int) -> void: # lvl = 0 for upgrade by 1 lvl, above 0  is to jump levels
	if lvl > 20 || lvl < 0:
		return
	
	if !lvl && max_level < 20: # if lvl is 0
		max_level += 1
	elif lvl:
		max_level = lvl
	update_stats(max_level)


# SIGNAL EMITTED HERE IS TO BE CONNECTED TO CAMERA IF DESIRED
func _on_SightRange_body_entered(target: RigidBody2D) -> void:
	if not target:
		return
	
	emit_signal("entered_sight", target)
	if target != self:
		eye_target = target

func _on_SightRange_body_exited(target: RigidBody2D) -> void:
	if target == eye_target:
		eye_target = null
	emit_signal("exited_sight", target)
