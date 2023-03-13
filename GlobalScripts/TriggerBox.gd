class_name TriggerBox # is to ACTIVATE HitBox with different collision shape
extends Area2D


func _init() -> void:
	input_pickable = false
	collision_layer = 0		# Disable collision layer because TriggerBox just scans for HurtBox
	collision_mask = 256	# layer 9 is to detect HurtBoxes

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_area_entered")

func _on_area_entered(hurtbox: HurtBox) -> void:
	if not hurtbox: # return if received a non HitBox collision
		return
	
	if owner.has_method("triggered"):
		owner.triggered()
