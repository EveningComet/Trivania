## Simply checks if the character has a target.
extends EnemyAction

func _tick(delta: float) -> Status:
	return SUCCESS if blackboard.get_var(_target_var) != null else FAILURE
