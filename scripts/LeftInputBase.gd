extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inpuleft_texture = preload("res://assets/images/InputLeft.png")
var inputleft_selected_texture = preload("res://assets/images/InputLeftSelected.png")
onready var animplay: AnimationPlayer = get_node("AnimPlay")
var icon = null

func _ready():
	print("input started")
	
	connect("focus_entered", self, "_focus_entered")
	connect("focus_exited", self, "_focus_exited")
	connect("text_changed", self, "_text_entered")
	
	icon = get_node_or_null("Icon")
	
	if icon != null:
		print(icon)
		animplay.root_node = "../Icon"

func _focus_entered():
	$LeftIcon.texture = inputleft_selected_texture

func _focus_exited():
	$LeftIcon.texture = inpuleft_texture

func text_entered(new_text):
	print('a')
	animplay.play("IconTyped")
