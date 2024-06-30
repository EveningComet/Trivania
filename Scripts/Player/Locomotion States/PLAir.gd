## For when the player is in the air.
class_name PLAir extends PLState

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	# Setup the gravity
	gravity = (2 * max_jump_height) / (time_to_jump_apex * time_to_jump_apex)
	max_jump_velocity = sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = sqrt(2 * gravity * min_jump_height)

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		
		# We entered from a jump
		{'velocity': var v, 'max_jump_velocity': var mjv}:
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
	
	if Input.is_action_just_released("jump") and velocity.y > min_jump_velocity:
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
	
func get_input_vector() -> void:
	# Get our movement value, adjusted to work with controllers
	input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir = input_dir.normalized() if input_dir.length() > 1 else input_dir
	
		# Move in the rotation of the camera
	# Also normalized so we don't move faster diagonally
	input_dir = input_dir.rotated(Vector3.UP, camera_controller.rotation.y).normalized() if input_dir.length() > 1 else input_dir.rotated(Vector3.UP, camera_controller.rotation.y)

func apply_movement(delta: float) -> void:
	if input_dir != Vector3.ZERO:
		velocity.x = velocity.move_toward(input_dir * move_speed, air_accel * delta).x
		velocity.z = velocity.move_toward(input_dir * move_speed, air_accel * delta).z
		
		# Face the direction we're moving
		cb.rotation.y = lerp_angle(
			cb.rotation.y,
			atan2(-input_dir.x, -input_dir.z),
			rot_speed * delta
		)

func apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, air_friction * delta)

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
