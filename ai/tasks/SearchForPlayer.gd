extends BTAction

var target_var: StringName = &"target"

func _tick(delta: float) -> Status:
	# TODO: Better way of getting the player.
	var player = agent.get_parent().owner.get_node("Player")
	if player != null:
		if agent.is_los_valid(player) == true:
			blackboard.set_var(target_var, player)
			return SUCCESS
		
	return FAILURE
