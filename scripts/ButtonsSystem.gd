extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var buttons_container = get_node_or_null("/root/Main/Controls/ButtonsContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_button(icon_name: String, action_text: String):
	if buttons_container == null:
		return
	
	var new_button = preload("res://scenes/ControlBtn.tscn").instance()
	
	var icon: TextureRect = new_button.get_node("Icon")
	var label: Label = new_button.get_node("Label")
	
	icon.texture = load("res://assets/images/buttons/" + icon_name + ".png")
	label.text = action_text.to_upper()
	
	buttons_container.add_child(new_button)
