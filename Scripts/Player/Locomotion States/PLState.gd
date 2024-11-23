## Base class that describes how the player should move at a given time.
class_name PLState extends State

@export_category("Movement Speed Values")
@export var move_speed:      float = 10   # How fast this state moves
@export var accel:           float = 60.0
@export var friction:        float = 50.0
@export var rot_speed:       float = 10.0 # How fast the character rotates in this state

## Every state requires movement in some form.
var _cb: CharacterBody3D

## The state's _velocity.
var _velocity: Vector3 = Vector3.ZERO

## The stored input for the state.
var _input_dir: Vector3 = Vector3.ZERO

var _input_controller:  PlayerInputController
var _camera_controller: CameraController
var _skin_handler:      SkinHandler
var _locomotion_anim_sm: AnimationNodeStateMachinePlayback

func setup_state(new_sm: PlayerLocomotionController) -> void:
	super(new_sm)
	
	_cb                = new_sm.cb
	_camera_controller = new_sm.camera_controller
	_input_controller  = new_sm.input_controller
	_skin_handler      = new_sm.skin_handler
	_locomotion_anim_sm = _skin_handler.animation_tree.get("parameters/locomotion/playback")

func physics_update(delta: float) -> void:
	_handle_move( delta )

func _handle_move(delta: float) -> void:
	_get_input_vector()
	_face_camera_dir( delta )
	
func _get_input_vector() -> void:
	# Get our movement value, adjusted to work with controllers
	_input_dir = _input_controller.input_dir
	
	# Change the input to be based on our forward direction
	_input_dir = _cb.transform.basis * Vector3(_input_dir.x, 0.0, _input_dir.z)
	
	# Apply the movement, taking into account gamepad input strength
	_input_dir = _input_dir.normalized() if _input_dir.length() > 1 else _input_dir

## Apply acceleration.
func _apply_movement(delta: float) -> void:
	if _input_dir != Vector3.ZERO:
		_velocity.x = _velocity.move_toward(_input_dir * move_speed, accel * delta).x
		_velocity.z = _velocity.move_toward(_input_dir * move_speed, accel * delta).z

func _handle_animations(delta: float) -> void:
	pass

## Apply a force to make the character stop moving.
func _apply_friction(delta: float) -> void:
	if _input_dir == Vector3.ZERO:
		_velocity.x = _velocity.move_toward(Vector3.ZERO, friction * delta).x
		_velocity.z = _velocity.move_toward(Vector3.ZERO, friction * delta).z

## Checks if the player can dash.
func _check_for_dashing() -> void:
	if _input_controller.dash_pressed == true:
		var dash_dir = -_cb.transform.basis.z
		if _input_dir != Vector3.ZERO:
			dash_dir = _input_dir
			
		my_state_machine.change_to_state("PLDash", {"velocity" = _velocity, "dash_dir" = dash_dir})

## Handles orienting the character towards a direction.
func _orient_character_to_direction(direction: Vector3, delta: float) -> void:
	var q_from = _cb.transform.basis.get_rotation_quaternion()
	var left_axis = Vector3.UP.cross(direction)
	var rotation_basis = Basis(left_axis, Vector3.UP, direction).get_rotation_quaternion()
	_cb.basis = Basis(q_from.slerp(rotation_basis, delta * rot_speed))
	_cb.transform.basis = _cb.transform.basis.orthonormalized() # Prevent weird stuff from happening

func _face_camera_dir(delta: float) -> void:
	var camera_dir := (_camera_controller.global_transform.basis * Vector3.BACK).normalized()
	_orient_character_to_direction(camera_dir, delta)

## Is the character currently on the floor?
func _is_on_floor() -> bool:
	return _cb.is_on_floor()
