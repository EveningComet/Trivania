## Notifies something when the player enters this area.
class_name AreaEventTrigger extends Area3D

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )

func _on_body_entered(body) -> void:
	if body is Player:
		pass

func _on_body_exited(body) -> void:
	if body is Player:
		pass
