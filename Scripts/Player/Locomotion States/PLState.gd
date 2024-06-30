## Base class that describes how the player should move at a given time.
class_name PLState extends State

@export_category("Movement Speed Values")
@export var move_speed:      float = 10   # How fast this state moves
@export var ground_accel:    float = 60.0
@export var ground_friction: float = 50.0
@export var air_accel:       float = 20.0
@export var air_friction:    float = 20.0
@export var rot_speed:       float = 10.0 # How fast the character rotates in this state

# Jump & gravity
@export_category("Jumping & Gravity Values")
@export var time_to_jump_apex: float = 0.4 # How long, in seconds, it takes us to reach the height of our jump
@export var max_jump_height:   float = 4   # How high we can jump
@export var min_jump_height:   float = 1   # How low we can jump
var max_jump_velocity: float = 0
var min_jump_velocity: float = 0
var gravity:           float = 9.8

## Every state requires movement in some form.
var cb: CharacterBody3D

## The state's velocity.
var velocity: Vector3 = Vector3.ZERO

## The stored input for the state.
var input_dir: Vector3 = Vector3.ZERO

var camera_controller: CameraController

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	cb = new_sm.cb
	camera_controller = new_sm.camera_controller

func physics_update(delta: float) -> void:
	handle_move( delta )

func handle_move(delta: float) -> void:
	pass

func handle_gravity(delta: float) -> void:
	pass

func get_input_vector() -> void:
	pass

func apply_movement(delta: float) -> void:
	pass

func apply_friction(delta: float) -> void:
	pass

## Handles orienting the character towards a direction.
func orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var q_from = cb.transform.basis.get_rotation_quaternion()
	var left_axis = Vector3.UP.cross(direction)
	var rotation_basis = Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
	cb.basis = Basis(q_from.slerp(rotation_basis, delta * rot_speed))
	cb.transform.basis = cb.transform.basis.orthonormalized() # Prevent weird stuff from happening

func check_if_on_ground_or_ceiling() -> void:
	# Don't calculate gravity if we're on the ground and make us fall down when hitting the ceiling
	if cb.is_on_floor() == true or cb.is_on_ceiling() == true:
		velocity.y = 0
