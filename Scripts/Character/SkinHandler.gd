## Used to help with a character's model and animations. Meant to be attached to the node
## that houses the model.
class_name SkinHandler extends Node3D

## The animation tree attached to the model.
@onready var animation_tree: AnimationTree = get_child(0).get_node("AnimationTree")

## Some things will need access to an IK thing.
@export var skeleton_ik: SkeletonIK3D

## Set a new model.
func set_model(new_model: Node3D) -> void:
	if get_child_count() > 0:
		get_child(0).queue_free()
	add_child(new_model)
	animation_tree = new_model.get_node("AnimationTree")
