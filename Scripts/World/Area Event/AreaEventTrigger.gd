## Notifies something when the player enters this area.
class_name AreaEventTrigger extends Area3D

signal player_entered(player: Player)
signal player_exited(player: Player)

## Should this destroy itself after it has done its job?
@export var one_shot: bool = false

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	body_exited.connect( _on_body_exited )

func _on_body_entered(body) -> void:
	if body is Player:
		if OS.is_debug_build() == true:
			print("AreaEventTrigger :: Player entered.")
		
		player_entered.emit(body)
		if one_shot == true:
			queue_free()

func _on_body_exited(body) -> void:
	if body is Player:
		player_exited.emit(body)
