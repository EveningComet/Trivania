## State for when the player is hanging off of something.
class_name PLLedgeGrab extends PLState

# How far away do we want to be from the collision point?
@export var horizontal_dist_away_from_ledge: float = -0.5
@export var vertical_dist_away_from_ledge:   float = 0.5

func enter(msgs: Dictionary = {}) -> void:
	var vert_collision_point = my_state_machine.vertical_ledge_cast.get_collision_point()
	var hori_collision_point = my_state_machine.horizontal_ledge_cast.get_collision_point()
	cb.global_transform.origin   = hori_collision_point - cb.basis.z * horizontal_dist_away_from_ledge
	cb.global_transform.origin.y = vert_collision_point.y - vertical_dist_away_from_ledge
	# TODO: Face the collision point.
	
	skin_handler.animation_tree.get("parameters/MovementStateMachine/playback").travel("hanging idle")

func exit() -> void:
	velocity = Vector3.ZERO

func physics_update(delta: float) -> void:
	handle_move(delta)

func handle_move(delta: float) -> void:
	if input_controller.jump_pressed:
		my_state_machine.change_to_state(
			"PLAir",
			{velocity = velocity, "jumping" = true}
		)
		return
	
	# TODO: Handle moving platforms.
