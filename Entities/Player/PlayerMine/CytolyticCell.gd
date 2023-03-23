extends Area2D


onready var state_machine


func _ready() -> void:
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true
	rotation = randf()
	$LifeTime.start()

func _on_LifeTime_timeout() -> void:
	state_machine.travel("explode")

func triggered() -> void: # To be called by TriggerBox
	state_machine.travel("explode")


# KNOCKBACK SYSTEM
func _on_CytolyticCell_body_entered(body: RigidBody2D) -> void:
	if body == null:
		return
	body.apply_central_impulse(position.direction_to(body.position) * 100)
