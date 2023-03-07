extends Area2D


onready var state_machine


func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true
	$LifeTime.start()

func triggered() -> void:
	state_machine.travel("explode")

func _on_LifeTime_timeout() -> void:
	state_machine.travel("explode")
	


# knockback system
func _on_CytolyticCell_body_entered(body: RigidBody2D) -> void:
	if body == null:
		return
	body.gravity_scale = 1


func _on_CytolyticCell_body_exited(body: RigidBody2D) -> void:
	if body == null:
		return
	body.gravity_scale = 0
	
