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
	if cb.is_on_floor() == true and Input.is_action_just_pressed("jump"):
		my_state_machine.change_to_state("PLAir", {velocity = velocity, "max_jump_velocity" = max_jump_velocity})
		return
	
	if cb.is_on_floor() == false:
		my_state_machine.change_to_state("PLAir", {velocity = velocity})
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
		velocity.x = velocity.move_toward(input_dir * move_speed, ground_accel * delta).x
		velocity.z = velocity.move_toward(input_dir * move_speed, ground_accel * delta).z
		
		# Face the direction we're moving
		cb.rotation.y = lerp_angle(
			cb.rotation.y,
			atan2(-input_dir.x, -input_dir.z),
			rot_speed * delta
		)

func apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		velocity = velocity.move_toward(Vector3.ZERO, ground_friction * delta)
