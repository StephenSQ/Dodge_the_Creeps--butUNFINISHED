class_name HurtBox # HurtBox is to RECEIVE damage
extends Area2D


func _init() -> void:
	collision_layer = 0		# Disable collision layer because HurtBox just scans for HitBox
	collision_mask = 256	# layer 9 is for HitBoxes


func _on_area_entered(hitbox: HitBox) -> void:
	if hitbox == null: # return if received a non HitBox collision
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
