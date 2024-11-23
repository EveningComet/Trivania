## BT task that moves an AI to a position.
extends BTAction

## How close to a target desitination before stopping.
@export var target_destination_distance: float = 2.0

var velocity: Vector3 = Vector3.ZERO

func _tick(delta: float) -> Status:
	
	# TODO: if target_destination_distance reached, return SUCCESS
	
	agent.cb.set_velocity(velocity)
	agent.cb.move_and_slide()
	
	return RUNNING
