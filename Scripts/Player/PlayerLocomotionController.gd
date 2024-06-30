## Controls the player's movement.
class_name PlayerLocomotionController extends StateMachine

@export var camera_controller: CameraController
@export var vertical_ledge_cast:   RayCast3D
@export var horizontal_ledge_cast: RayCast3D

var cb: CharacterBody3D

func set_me_up() -> void:
	cb = get_parent()
	super()

func _physics_process(delta: float) -> void:
	curr_state.physics_update(delta)
