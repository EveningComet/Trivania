## Tells the enemy to jump.
extends EnemyAction

@export var jump_force: float = 15.0

func _enter() -> void:
	if agent.cb.is_on_floor() == false:
		return
	# TODO: Better way of getting the player.
	var player = agent.get_parent().owner.get_node("Player")
	blackboard.set_var(_target_var, player)
	_original_speed   = _mover.move_speed
	_mover.move_speed = move_speed
	_target = blackboard.get_var(_target_var)
	_mover.set_target_position(_target.global_position)
	_mover.orient_to_direction(
		-agent.cb.global_position.direction_to( _target.global_position ),
		0.1
	)
	_mover.jump(jump_force)

func _tick(delta: float) -> Status:
	return SUCCESS if agent.cb.is_on_floor() == true else RUNNING
