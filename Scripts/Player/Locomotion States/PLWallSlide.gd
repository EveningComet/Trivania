## State for when the player is sliding down a wall.
class_name PLWallSlide extends PLState

## How fast we will slide down a wall.
@export var wallslide_speed:       float = 10.0
@export var wall_jump_away_force:  float = 15.0
@export var wall_jump_away_height: float = 25.0

func enter(msgs: Dictionary = {}) -> void:
	match msgs:
		{'velocity': var v}:
			_velocity = v
	

func exit() -> void:
	_velocity = Vector3.ZERO

func handle_move(delta: float) -> void:
	# We should exit now
	if _cb.is_on_floor() == true or _cb.is_on_wall() == false:
		my_state_machine.change_to_state("PLGround")
		return
	
	if Input.is_action_just_pressed("jump"):
		var normal = _cb.get_wall_normal()
		_velocity = normal * wall_jump_away_force
		
		my_state_machine.change_to_state(
			"PLAir",
			{_velocity = _velocity, "wall_jump_away_height" = wall_jump_away_height}
		)
		
	# Go downwards
	_velocity.y -= wallslide_speed * delta
	_cb.set_velocity( _velocity )
	_cb.move_and_slide()
