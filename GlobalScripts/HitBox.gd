class_name HitBox # HitBox is to DEAL damage
extends Area2D


var damage := 0


func _init() -> void:
	input_pickable = false
	collision_layer = 256	# Layer 9 to be detected by HurtBoxes
	collision_mask = 0		# Disable mask scanning because HitBox doesn't need its Collision Mask
