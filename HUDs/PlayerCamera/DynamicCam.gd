extends Camera2D


onready var screen_size = get_viewport_rect().size
var move_speed = 0.1
var zoom_speed = 0.2
var min_zoom = 0.5
var max_zoom = 20
var rect_margin = Vector2(400, 200)


func _ready():
# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")

func _on_viewport_size_changed() -> void:
	screen_size = get_viewport_rect().size
	print("viewport changed")


var tracked_targets = []

func add_target(target) -> void:
	if  not target in tracked_targets:
		tracked_targets.append(target)

func remove_target(target) -> void:
	if target in tracked_targets:
		tracked_targets.erase(target)


func _process(_delta) -> void:
	if !tracked_targets: 
		return
	
	var destination = Vector2.ZERO
	for target in tracked_targets:
		destination += target.position
	destination /= tracked_targets.size()
	position = lerp(position, destination, move_speed)
	
	var focus_rect = Rect2(position, Vector2.ONE)
	for target in tracked_targets:
		focus_rect = focus_rect.expand(target.position)
	focus_rect.grow_individual(rect_margin.x, rect_margin.y, rect_margin.x, rect_margin.y)
	
	var desired_zoom
	if focus_rect.size.x > focus_rect.size.y * screen_size.aspect():
		desired_zoom = clamp(focus_rect.size.x / screen_size.x, min_zoom, max_zoom)
	else:
		desired_zoom = clamp(focus_rect.size.y / screen_size.y, min_zoom, max_zoom)
	
	zoom = lerp(zoom, Vector2.ONE * desired_zoom, zoom_speed)


func _on_Player_entered_sight(target):
	add_target(target)


func _on_Player_exited_sight(target):
	remove_target(target)
