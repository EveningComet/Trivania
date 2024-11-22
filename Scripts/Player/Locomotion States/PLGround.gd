## State for when the player is moving normally on the ground.
class_name PLGround extends PLState

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# Entered with velocity from a previous state
		{'velocity': var v}:
			_velocity = v
	_locomotion_anim_sm.travel("movement")

func exit() -> void:
	_velocity = Vector3.ZERO

func _handle_move(delta: float) -> void:
	super(delta)
	_apply_movement( delta )
	_apply_friction( delta )
	
	_cb.set_velocity( _velocity )
	_cb.move_and_slide()
	
	# Air related checks
	if _is_on_floor() == true and _input_controller.jump_pressed == true:
		my_state_machine.change_to_state("PLAir", {"velocity" = _velocity, "jumping" = true})
		return
	
	if _is_on_floor() == false:
		my_state_machine.change_to_state("PLAir", {"velocity" = _velocity})
		return
	
	_check_for_dashing()
	_handle_animations(delta)

func _handle_animations(delta: float) -> void:
	var modified_dir = _velocity * _cb.transform.basis
	_skin_handler.animation_tree.set(
		"parameters/locomotion/movement/blend_position",
		Vector2(modified_dir.x, -modified_dir.z) / move_speed
	)
