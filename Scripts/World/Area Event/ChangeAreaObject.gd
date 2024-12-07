## Changes a part of the environment.
class_name ChangeAreaObject extends Node

# TODO: Figure out how to change the object without outright destroying it.

@export var object_to_change: Node3D

func _on_player_entered(player: Player) -> void:
	if object_to_change != null:
		object_to_change.queue_free()
