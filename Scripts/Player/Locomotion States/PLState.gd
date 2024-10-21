## Base class that describes how the player should move at a given time.
class_name PLState extends State

@export_category("Movement Speed Values")
@export var move_speed:      float = 10   # How fast this state moves
@export var accel:           float = 60.0
@export var friction:        float = 50.0
@export var rot_speed:       float = 10.0 # How fast the character rotates in this state

## Every state requires movement in some form.
var cb: CharacterBody3D

## The state's velocity.
var velocity: Vector3 = Vector3.ZERO

## The stored input for the state.
var input_dir: Vector3 = Vector3.ZERO

var input_controller:  PlayerInputController
var camera_controller: CameraController
var skin_handler:      SkinHandler
var locomotion_anim_sm: AnimationNodeStateMachinePlayback

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	cb                = new_sm.cb
	camera_controller = new_sm.camera_controller
	input_controller  = new_sm.input_controller
	skin_handler      = new_sm.skin_handler
	locomotion_anim_sm = skin_handler.animation_tree.get("parameters/MovementStateMachine/playback")

func physics_update(delta: float) -> void:
	handle_move( delta )

func handle_move(delta: float) -> void:
	pass

func handle_gravity(delta: float) -> void:
	pass

func get_input_vector() -> void:
	# Get our movement value, adjusted to work with controllers
	input_dir = Vector3.ZERO
	input_dir.x = input_controller.input_dir.x
	input_dir.z = input_controller.input_dir.z
	input_dir = input_dir.normalized() if input_dir.length() > 1 else input_dir
	
	# Move in the rotation of the camera
	# Also normalized so we don't move faster diagonally
	input_dir = input_dir.rotated(Vector3.UP, camera_controller.rotation.y).normalized() if input_dir.length() > 1 else input_dir.rotated(Vector3.UP, camera_controller.rotation.y)

func apply_movement(delta: float) -> void:
	if input_dir != Vector3.ZERO:
		velocity.x = velocity.move_toward(input_dir * move_speed, accel * delta).x
		velocity.z = velocity.move_toward(input_dir * move_speed, accel * delta).z
		
		# Face the direction we're moving
		cb.rotation.y = lerp_angle(
			cb.rotation.y,
			atan2(-input_dir.x, -input_dir.z),
			rot_speed * delta
		)

func apply_friction(delta: float) -> void:
	if input_dir == Vector3.ZERO:
		velocity.x = velocity.move_toward(Vector3.ZERO, friction * delta).x
		velocity.z = velocity.move_toward(Vector3.ZERO, friction * delta).z

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
