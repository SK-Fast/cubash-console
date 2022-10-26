extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var notify_container = get_node_or_null("/root/Main/NotifyContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func notify(header, content):
	print("NOTIFY")
	
	if notify_container == null:
		print("IS NULL, GO AWAY")
		return
	
	var new_notify = preload("res://scenes/Notify.tscn").instance()
	
	var container = new_notify.get_node("NotifyContainer")
	var notify_anim = container.get_node("AnimPlay")
	var notify_content = container.get_node("Content")
	
	notify_anim.play("Popup")
	
	notify_content.get_node("Heading").text = header
	notify_content.get_node("Sub").text = content
	
	notify_container.add_child(new_notify)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
