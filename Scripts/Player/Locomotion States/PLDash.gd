## The locomotion state for when the player is dashing.
class_name PLDash extends PLState

## How long the player is allowed to be in this state, in seconds.
@export var max_dash_time: float = 0.5
var _curr_dash_time:       float = 0.0

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'velocity': var v, 'dash_dir': var dd}:
			_velocity  = v
			_input_dir = dd

func exit() -> void:
	_input_dir      = Vector3.ZERO
	_curr_dash_time = 0.0
	_velocity       = Vector3.ZERO

func _handle_move(delta: float) -> void:
	_apply_movement( delta )
	_cb.set_velocity(_velocity)
	_cb.move_and_slide()
	_curr_dash_time += delta
	
	if _is_on_floor() == true and _input_controller.jump_pressed == true:
		my_state_machine.change_to_state(
			"PLAir", {"velocity" = _velocity, "jumping" = true}
		)
		return
	
	if _curr_dash_time > max_dash_time:
		if _is_on_floor() == true:
			my_state_machine.change_to_state("PLGround", {"velocity" = _velocity})
			return
		else:
			my_state_machine.change_to_state("PLAir", {"velocity" = _velocity})
			return
