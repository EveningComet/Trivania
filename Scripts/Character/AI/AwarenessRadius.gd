## Helps the AI notice characters around them.
class_name AwarenessRadius extends Area3D

var potential_targets: Array = []

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )

func _on_body_entered(body) -> void:
	if body is Player:
		potential_targets.append(body)

func _on_body_exited(body) -> void:
	if body is Player and potential_targets.has(body) == true:
		potential_targets.erase(body)
