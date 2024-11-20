## State for when the player is hanging off of something.
class_name PLLedgeGrab extends PLState

# How far away do we want to be from the collision point?
@export var horizontal_dist_away_from_ledge: float = -0.5
@export var vertical_dist_away_from_ledge:   float = 0.5

func enter(msgs: Dictionary = {}) -> void:
	var vert_collision_point = my_state_machine.vertical_ledge_cast.get_collision_point()
	var hori_collision_point = my_state_machine.horizontal_ledge_cast.get_collision_point()
	_cb.global_transform.origin   = hori_collision_point - _cb.basis.z * horizontal_dist_away_from_ledge
	_cb.global_transform.origin.y = vert_collision_point.y - vertical_dist_away_from_ledge
	# TODO: Face the collision point.
	
	_skin_handler.animation_tree.get("parameters/MovementStateMachine/playback").travel("hanging idle")

func exit() -> void:
	_velocity = Vector3.ZERO

func _handle_move(delta: float) -> void:
	if _input_controller.jump_pressed == true:
		my_state_machine.change_to_state(
			"PLAir",
			{"velocity" = _velocity, "jumping" = true}
		)
		return
	
	# TODO: Handle moving platforms.
