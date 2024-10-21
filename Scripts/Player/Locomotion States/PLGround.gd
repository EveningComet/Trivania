## State for when the player is moving normally on the ground.
class_name PLGround extends PLState

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# Entered with velocity from a previous state
		{'velocity': var v}:
			velocity = v

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	get_input_vector()
	apply_movement( delta )
	apply_friction( delta )
	
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	check_if_on_ground_or_ceiling()
	
	# Air related checks
	if cb.is_on_floor() == true and input_controller.jump_pressed == true:
		my_state_machine.change_to_state("PLAir", {velocity = velocity, "jumping" = true})
		return
	
	if cb.is_on_floor() == false:
		my_state_machine.change_to_state("PLAir", {velocity = velocity})
		return
