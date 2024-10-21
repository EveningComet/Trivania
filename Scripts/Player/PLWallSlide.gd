## State for when the player is sliding down a wall.
class_name PLWallSlide extends PLState

## How fast we will slide down a wall.
@export var wallslide_speed:       float = 10.0
@export var wall_jump_away_force:  float = 15.0
@export var wall_jump_away_height: float = 25.0

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'velocity': var v}:
			velocity = v
	

func exit() -> void:
	velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	# We should exit now
	if cb.is_on_floor() == true or cb.is_on_wall() == false:
		my_state_machine.change_to_state("PLGround")
		return
	
	if Input.is_action_just_pressed("jump"):
		var normal = cb.get_wall_normal()
		velocity = normal * wall_jump_away_force
		
		my_state_machine.change_to_state(
			"PLAir",
			{velocity = velocity, "wall_jump_away_height" = wall_jump_away_height}
		)
		
	# Go downwards
	velocity.y -= wallslide_speed * delta
	cb.set_velocity( velocity )
	cb.move_and_slide()
	
	var cam_dir = (my_state_machine.camera_controller.global_transform.basis * Vector3.BACK).normalized()
	orient_character_to_direction(cam_dir, delta)
