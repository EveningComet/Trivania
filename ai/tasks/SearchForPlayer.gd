extends BTAction

var target_var: StringName = &"target"

func _tick(delta: float) -> Status:
	if agent.awareness_radius.potential_targets.size() > 0:
		var player = agent.awareness_radius.potential_targets[0]
		if player != null:
			if agent.is_los_valid(player) == true:
				blackboard.set_var(target_var, player)
				return SUCCESS
		
	return FAILURE
