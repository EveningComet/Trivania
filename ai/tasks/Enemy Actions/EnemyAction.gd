## Base class for something an enemy character can do.
class_name EnemyAction extends BTAction

## Some actions should change the enemy's speed.
@export var move_speed: float = 7.5

## The original speed for the character before the tree changed it.
var _original_speed: float = 0.0

## Used to help store the character this character targets in the blackboard.
var _target_var: StringName = &"target"

## Stores the target. Gotten through the blackboard.
var _target: Node3D

var _mover: AIMover

func _setup() -> void:
	_mover = agent.mover
	_original_speed = _mover.move_speed

func _exit() -> void:
	_mover.move_speed = _original_speed
	
