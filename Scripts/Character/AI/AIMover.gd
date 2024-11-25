## Component meant to be attached to AI characters that need to move.
class_name AIMover extends Node

## How fast this character should move.
@export var speed: float = 7.5
@export var gravity: float = 35.0

@onready var _cb: CharacterBody3D = get_parent()
@onready var _nav_agent: NavigationAgent3D = get_parent().get_node("NavigationAgent3D")

## Stores the movement vector for this character.
var _velocity: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	_velocity.y -= gravity * delta
	if _cb.is_on_floor() or _cb.is_on_ceiling():
		_velocity.y = 0.0
	
	# Apply the movement
	_cb.set_velocity(_velocity)
	_cb.move_and_slide()
