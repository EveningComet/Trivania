## Controls the camera for the player.
class_name CameraController extends SpringArm3D

## Controls how fast the camer moves.
@export var speed: float = 20.0

## The node where the player is stored.
@export var target: Node3D
@export var offset: Vector3 = Vector3(0, 1.5, 0)

## Used to help with the aiming direction.
@onready var _aim_cast: RayCast3D = $Camera3D/Aimcast

var mouse_sensitivity:      float = 0.1 # TODO: Clamp this between 0.1 and 1. Also, make this a global setting.
var controller_sensitivity: float = 2.5 # TODO: Make this a global setting.

# The minimum and maximum allowed tilt for this camera
var min_pitch: float = -75.0
var max_pitch: float = 75.0

var wrap_0:   float = 0.0
var wrap_max: float = 360.0

func _ready() -> void:
	set_as_top_level(true)
	add_excluded_object( target.get_rid() )
	_aim_cast.add_exception( get_parent() )

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate the x, and clamp the values
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
			
		# Rotate for the y, and clamp the values so it doesn't go over values for reasons
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, wrap_0, wrap_max)

func _physics_process(delta: float) -> void:
	move_camera( delta )

func move_camera(delta: float) -> void:
	apply_controller_rotation()
	
	global_position = lerp(global_position, target.global_position + offset, speed * delta)

func apply_controller_rotation() -> void:
	var axis_vector = Vector2.ZERO
	axis_vector.y = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.x = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	if InputEventJoypadMotion:
		
		# Handle the controller's x rotation
		rotation_degrees.x -= axis_vector.x * controller_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, min_pitch, max_pitch)
		
		# Handle the controller's y rotation
		rotate_y( deg_to_rad(-axis_vector.y) * controller_sensitivity )
		rotation_degrees.y = wrapf(rotation_degrees.y, wrap_0, wrap_max)

## Used to get the direction of where the camera is facing for aiming.
func get_aim_target() -> Vector3:
	return _aim_cast.global_transform * _aim_cast.target_position
