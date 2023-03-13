class_name HurtBox # HurtBox is to RECEIVE damage
extends Area2D


func _init() -> void:
	input_pickable = false
	collision_layer = 256	# layer 9 to be detected by TriggerBoxes
	collision_mask = 256	# layer 9 to detect HitBoxes


func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_area_entered")


func _on_area_entered(hitbox: HitBox) -> void:
	if not hitbox: # return if received a non HitBox collision
		return
	
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
