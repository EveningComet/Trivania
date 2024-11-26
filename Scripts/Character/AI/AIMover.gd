## Component meant to be attached to AI characters that need to move.
class_name AIMover extends Node

@export_category("Movement Control Variables")
## How fast to move in this state. (Has nothing to do with stats.)
@export var move_speed: float = 7.5
## How fast it takes the character to get to their top speed.
@export var accel:     float = 60.0
## When not moving, this will help make the character stop moving.
@export var friction:  float = 50.0
@export var rot_speed: float = 10.0

@export_category("Gravity")
@export var gravity: float = 30.0

@onready var _cb: CharacterBody3D = get_parent()
@onready var _skin_handler: SkinHandler = get_parent().get_node("SkinHandler")
@onready var _nav_agent: NavigationAgent3D = get_parent().get_node("NavigationAgent3D")

## Stores the movement vector for this character.
var _velocity: Vector3 = Vector3.ZERO

## Stores direction this character should move.
var _input_dir: Vector3 = Vector3.ZERO

var _last_dir: Vector3 = Vector3.ZERO

func _ready() -> void:
	_nav_agent.velocity_computed.connect( _on_velocity_computed )
	set_target_position(_cb.global_position)

func _physics_process(delta: float) -> void:
	if _nav_agent.is_navigation_finished() == true:
		_input_dir = Vector3.ZERO
	else:
		var next_path_position: Vector3 = _nav_agent.get_next_path_position()
		_input_dir = (next_path_position - _cb.global_position).normalized()
		_last_dir = _input_dir
	
	_apply_acceleration(delta)
	_apply_friction(delta)
	_velocity.y -= gravity * delta
	
	_on_velocity_computed(_velocity)
	_handle_animations(delta)

	if _cb.is_on_floor() or _cb.is_on_ceiling():
		_velocity.y = 0.0

func set_target_position(target_pos: Vector3) -> void:
	_nav_agent.set_target_position( target_pos )

## Used to make the character face the direction.
func orient_to_direction(desired_dir: Vector3, delta: float) -> void:
	var left_axis      = Vector3.UP.cross(desired_dir)
	var rotation_basis = Basis(left_axis, Vector3.UP, desired_dir).get_rotation_quaternion()
	var q_from         = _cb.transform.basis.get_rotation_quaternion()
	_cb.basis          = Basis(q_from.slerp(rotation_basis, rot_speed * delta))
	
	# Prevent weird stuff from happening
	_cb.transform.basis = _cb.transform.basis.orthonormalized()

## Perform a jump with the given force.
func jump(jump_force: float) -> void:
	_velocity.y = jump_force
	_skin_handler.animation_tree["parameters/locomotion/playback"].travel("jump")

## Applies the movement with smoothing.
func _apply_acceleration(delta: float) -> void:
	if _input_dir != Vector3.ZERO:
		_velocity.x = _velocity.move_toward(_input_dir * move_speed, accel * delta).x
		_velocity.z = _velocity.move_toward(_input_dir * move_speed, accel * delta).z

## Makes the stopping smooth.
func _apply_friction(delta: float) -> void:
	if _input_dir == Vector3.ZERO:
		_velocity.x = _velocity.move_toward(Vector3.ZERO, friction * delta).x
		_velocity.z = _velocity.move_toward(Vector3.ZERO, friction * delta).z

func _handle_animations(delta: float) -> void:
	if _cb.is_on_floor() == false:
		_skin_handler.animation_tree["parameters/locomotion/playback"].travel("falling")
	elif _cb.is_on_floor() == true:
		_skin_handler.animation_tree["parameters/locomotion/playback"].travel("movement")
		var modified_dir: Vector3 = _velocity * _cb.transform.basis
		_skin_handler.animation_tree.set(
			"parameters/locomotion/movement/blend_position",
			Vector2(modified_dir.x, -modified_dir.z) / move_speed
		)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	_cb.set_velocity(safe_velocity)
	_cb.move_and_slide()
