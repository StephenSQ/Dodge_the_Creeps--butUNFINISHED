extends Node

export var CytolyticCell_scene: PackedScene
export var players: PackedScene

enum camera_action {HIT, DIE}
signal screenshake # to make camera do screenshake

func _ready() -> void:
	# spawn players in all levels
#	for i in range(20):
#		var player_test = players.instance()
#		player_test.position = Vector2(0, i * 50)
#		player_test.rotation = PI / 2.0
#		player_test.connect("attack", self, "_on_Player_attack")
#		player_test.max_level = i + 1
#		$DynamicCam.add_target(player_test)
#		add_child(player_test)
	
	# compare default stats to max stats
#	$DynamicCam.add_target($Player)
#	$DynamicCam.add_target($Player2)
#	$Player.max_level = 1
#	$Player.update_stats($Player.max_level)
## warning-ignore:return_value_discarded
#	$Player.connect("attack", self, "_on_Player_attack")
#	$Player2.max_level = 20
#	$Player2.update_stats($Player2.max_level)
## warning-ignore:return_value_discarded
#	$Player2.connect("attack", self, "_on_Player_attack")
#	print($Player.max_health)
#	print($Player2.max_health)
	
	$DynamicCam.add_target($Player)
	$Player.upgrade(20)


func _on_Player_attack(damage, player) -> void:
	var player_mine = CytolyticCell_scene.instance()
	player_mine.position = player.position
	player_mine.get_node("HitBox").damage = damage
	add_child(player_mine)


func _on_Player_hit():
	emit_signal("screenshake", camera_action.HIT)


func _on_Player_died():
	emit_signal("screenshake", camera_action.DIE)
