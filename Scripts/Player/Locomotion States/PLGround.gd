## State for when the player is moving normally on the ground.
class_name PLGround extends PLState

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# Entered with velocity from a previous state
		{'velocity': var v}:
			_velocity = v
	locomotion_anim_sm.travel("locomotion")

func exit() -> void:
	_velocity = Vector3.ZERO

func _handle_move(delta: float) -> void:
	_get_input_vector()
	_apply_movement( delta )
	_apply_friction( delta )
	
	_cb.set_velocity( _velocity )
	_cb.move_and_slide()
	
	_skin_handler.animation_tree.set("parameters/MovementStateMachine/locomotion/blend_position", _cb.velocity.length() / move_speed)
	
	# Air related checks
	if _is_on_floor() == true and _input_controller.jump_pressed == true:
		my_state_machine.change_to_state("PLAir", {"velocity" = _velocity, "jumping" = true})
		return
	
	if _is_on_floor() == false:
		my_state_machine.change_to_state("PLAir", {"velocity" = _velocity})
		return
	
	_check_for_dashing()
