## Stores the information the player needs to see at a given time.
class_name PlayerHUD extends CanvasLayer

## Reference to the player's node to get needed information.
@export var player: Player

@onready var player_hp_bar: Vitalbar = $"Control/Player HB"

func _ready() -> void:
	player_hp_bar.set_monitorable(player.damageable)
