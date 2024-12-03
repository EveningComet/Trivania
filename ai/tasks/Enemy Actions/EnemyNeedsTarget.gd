## Does the enemy have to search for a target?
extends EnemyAction

func _tick(delta: float) -> Status:
	if blackboard.get_var(_target_var) == null:
		return SUCCESS
	
	# The enemy already has a target. No need to search
	return FAILURE
