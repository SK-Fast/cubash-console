extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var swipe_start = null
var screen_start_pos = null
var minimum_drag = 100
var dragging = false

var swiping_out = false
var swiping_out_pos = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func gui_input(event):
	if event.is_action_pressed("swipe"):
		screen_start_pos = get_global_rect().position
		swipe_start = get_global_mouse_position()
		dragging = true
	if event.is_action_released("swipe"):
		swipe_start = null
		dragging = false
		swipe_away()


func _input(event):
	if event is InputEventMouseMotion and dragging:
		var x_pos = (((swipe_start + event.position) - screen_start_pos).x) - get_global_rect().size.x
		
		set_global_position(Vector2(
			x_pos,
			get_global_rect().position.y
		))
		
		var size_x_win = get_viewport().size.x
		
		rect_rotation = lerp(rect_rotation, ((size_x_win - x_pos) / 100) * -1, 0.25)
		

func _process(_delta):
	if swiping_out:
		set_global_position(swiping_out_pos)

func swipe_away():
	swiping_out_pos = get_global_rect().position
	swiping_out = true
	$NotifyContainer/AnimPlay.play("swipe_away")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NotifyContainer_gui_input(event):
	if event.is_action_pressed("swipe"):
		screen_start_pos = get_global_rect().position
		swipe_start = get_global_mouse_position()
		dragging = true
	if event.is_action_released("swipe"):
		swipe_start = null
		dragging = false
		swipe_away()
