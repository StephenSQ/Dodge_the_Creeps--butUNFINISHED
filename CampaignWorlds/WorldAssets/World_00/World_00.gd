extends Node


export var CytolyticCell_scene: PackedScene
export var players: PackedScene

onready var camera = $MainCamera

func _ready() -> void:
	# spawn players in all levels
#	for i in range(20):
#		var player_test = players.instance()
#		player_test.position = Vector2(0, i * 25)
#		player_test.rotation = PI / 2.0
#		player_test.connect("attack", self, "_on_Player_attack")
#		player_test.connect("hit", self, "_on_Player_hit")
#		player_test.connect("died", self, "_on_Player_died")
#		player_test.max_level = i + 1
#		camera.add_target(player_test)
#		add_child(player_test)
	
	# compare default stats to max stats
	for i in range(1):
		var player_test = players.instance()
		player_test.position = Vector2(0, i * 25)
		player_test.connect("attack", self, "_on_Player_attack")
		player_test.connect("hit", self, "_on_Player_hit")
		player_test.connect("died", self, "_on_Player_died")
		player_test.max_level = 1 if i == 20 else 20
		print(player_test.max_level)
		camera.add_target(player_test)
		add_child(player_test)


func _on_Player_attack(damage, player) -> void:
	var player_mine = CytolyticCell_scene.instance()
	player_mine.position = player.position
	player_mine.get_node("HitBox").damage = damage
	add_child(player_mine)


func _on_Player_hit():
	camera.screenshake(5)

func _on_Player_died(player):
	camera.remove_target(player)
	camera.screenshake(10)
