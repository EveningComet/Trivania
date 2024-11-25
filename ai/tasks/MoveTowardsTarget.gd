## BT task that tells a character to move towards someone.
extends BTAction

## How close to a target desitination before stopping.
@export var target_destination_distance: float = 3.0
@export var target_var: StringName = &"target"

var _max_distance_squared: float

var target: Node3D

func _setup() -> void:
	_max_distance_squared = target_destination_distance * target_destination_distance

func _enter() -> void:
	target = blackboard.get_var(target_var)

func _exit() -> void:
	target = null

func _tick(delta: float) -> Status:
	if target != null:
		# TODO: Cooldown on recalculating path.
		agent.mover.set_target_position(target.global_position)
		
		agent.mover.orient_to_direction( 
			-agent.get_parent().global_position.direction_to(target.global_position),
			delta
		)
		
		var dist_sqr = agent.get_parent().global_position.distance_squared_to( target.global_position )
		if dist_sqr <= _max_distance_squared:
			agent.mover.set_target_position(agent.get_parent().global_position)
			return SUCCESS
			
		return RUNNING
			
	return FAILURE
