extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func parse_header(header: PoolStringArray):
	var result = {}
	
	for t in header:
		var splitted = t.split(":")
		var key = splitted[0]
		var val = splitted[1]
		
		result[key] = val
	
	return result


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
