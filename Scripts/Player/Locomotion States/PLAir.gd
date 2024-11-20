## For when the player is in the air.
class_name PLAir extends PLState

# Jump & _gravity
@export_category("Jumping & Gravity Values")
@export var time_to_jump_apex: float = 0.4 ## How long, in seconds, it takes us to reach the height of our jump
@export var max_jump_height:   float = 4   ## How high we can jump
@export var min_jump_height:   float = 1   ## How low we can jump
var _max_jump_velocity: float = 0
var _min_jump_velocity: float = 0
var _gravity:           float = 9.8

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	# Setup the _gravity
	_gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	_max_jump_velocity = sqrt(2 * _gravity * max_jump_height)
	_min_jump_velocity = sqrt(2 * _gravity * min_jump_height)

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# We entered from a jump
		{'velocity': var v, 'jumping': var mjv}:
			_velocity   = v
			_velocity.y = _max_jump_velocity
			locomotion_anim_sm.travel("jump")
		
		# Entered from a fall
		{'velocity': var v}:
			_velocity = v
			locomotion_anim_sm.travel("falling")

func exit() -> void:
	_velocity = Vector3.ZERO

func _handle_move(delta: float) -> void:
	_get_input_vector()
	_apply_movement( delta )
	_apply_friction( delta )
	
	if _input_controller.jump_released == true and _velocity.y > _min_jump_velocity:
		_velocity.y = _min_jump_velocity
	
	_velocity.y -= _gravity * delta
	_cb.set_velocity( _velocity )
	_cb.move_and_slide()
	
	if _cb.is_on_ceiling() == true:
		_velocity.y = 0
	
	# Check for ledge grabs
	if _can_ledge_grab() == true:
		my_state_machine.change_to_state("PLLedgeGrab")
		return
	
	if _is_on_floor() == true:
		_velocity.y = 0
		my_state_machine.change_to_state("PLGround", {_velocity = _velocity})
		return

func _can_ledge_grab() -> bool:
	# Only ledge grab when the player is falling
	if _cb.is_on_floor() == false and _velocity.y < 0.0:
		var vertical_ledge_cast: RayCast3D = my_state_machine.vertical_ledge_cast
		var horizontal_ledge_cast: RayCast3D = my_state_machine.horizontal_ledge_cast
		if vertical_ledge_cast.is_colliding() == true:
			var vert_collision_point = vertical_ledge_cast.get_collision_point()
			horizontal_ledge_cast.global_transform.origin.y = vert_collision_point.y - 0.01
			
			# Ledge grab if all the checks are clear
			if horizontal_ledge_cast.is_colliding() == true:
				return true
	return false
