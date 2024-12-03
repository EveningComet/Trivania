## Stores various helper functions.
class_name Utils extends Node

## Checks the passed node to see if it contains a node of the passed type.
static func get_node_of_type(parent: Node, type):
	for child in parent.get_children():
		if is_instance_of(child, type):
			return child
	
	return null
