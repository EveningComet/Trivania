## For when the player is in the air.
class_name PLAir extends PLState

# Jump & gravity
@export_category("Jumping & Gravity Values")
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
@export var max_jump_height:   float = 4   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
var max_jump_velocity: float = 0
var min_jump_velocity: float = 0
var gravity:           float = 9.8

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	# Setup the gravity
	gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	max_jump_velocity = sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity * min_jump_height)

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# We entered from a jump
		{'velocity': var v, 'jumping': var mjv}:
			velocity   = v
			velocity.y = max_jump_velocity
		
		# Entered from a fall
		{'velocity': var v}:
			velocity = v

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	get_input_vector()
	apply_movement( delta )
	apply_friction( delta )
	
	if input_controller.jump_released == true and velocity.y > min_jump_velocity:
		velocity.y = min_jump_velocity
	
	velocity.y -= gravity * delta
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	if cb.is_on_ceiling() == true:
		velocity.y = 0
	
	# Check for ledge grabs
	if can_ledge_grab() == true:
		my_state_machine.change_to_state("PLLedgeGrab")
		return
	
	if cb.is_on_floor() == true:
		velocity.y = 0
		my_state_machine.change_to_state("PLGround", {velocity = velocity})
		return

func can_ledge_grab() -> bool:
	# Only ledge grab when the player is falling
	if cb.is_on_floor() == false and velocity.y < 0.0:
		var vertical_ledge_cast: RayCast3D = my_state_machine.vertical_ledge_cast
		var horizontal_ledge_cast: RayCast3D = my_state_machine.horizontal_ledge_cast
		if vertical_ledge_cast.is_colliding() == true:
			var vert_collision_point = vertical_ledge_cast.get_collision_point()
			horizontal_ledge_cast.global_transform.origin.y = vert_collision_point.y - 0.01
			
			# Ledge grab if all the checks are clear
			if horizontal_ledge_cast.is_colliding() == true:
				return true
	return false
