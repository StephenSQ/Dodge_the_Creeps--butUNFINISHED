extends Node

export var CytolyticCell_scene: PackedScene

func _ready() -> void:
	$DynamicCam.add_target($Player)


func _on_Player_attack(damage) -> void:
	var player_mine = CytolyticCell_scene.instance()
	player_mine.position = $Player.position
	player_mine.get_node("HitBox").damage = damage
	add_child(player_mine)
