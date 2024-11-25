extends BTAction

@export var target_var: StringName = &"target"

var target: Node3D

func _enter() -> void:
	target = blackboard.get_var(target_var)

func _tick(delta: float) -> Status:
	if target != null:
		agent.mover.orient_to_direction( 
			-agent.get_parent().global_position.direction_to(target.global_position),
			delta
		)
		return RUNNING
	return FAILURE
