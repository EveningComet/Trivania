extends BTAction

@export var max_distance: float = 3.0
@export var min_distance: float = 1.0
@export var target_var: StringName = &"target"

var _max_distance_squared: float
var _min_distance_squared: float

var target: Node3D

func _setup() -> void:
	_max_distance_squared = max_distance * max_distance
	_min_distance_squared = min_distance * min_distance

func _enter() -> void:
	target = blackboard.get_var(target_var)

func _tick(delta: float) -> Status:
	if target != null:
		var dist_sqr = agent.get_parent().global_position.distance_squared_to( target.global_position )
		if dist_sqr <= _max_distance_squared:
			return SUCCESS
	return FAILURE
