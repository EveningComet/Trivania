extends EnemyAction

func _tick(delta: float) -> Status:
	return SUCCESS if agent.cb.is_on_floor() == true else FAILURE
