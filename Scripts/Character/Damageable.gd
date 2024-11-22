## A component meant to be attached to objects that can take damage and die.
class_name Damageable extends Node

@export var max_hp: int = 50
var curr_hp:        int = 0

func _ready() -> void:
	curr_hp = max_hp

func take_damage(damage_data) -> void:
	pass

func upgrade_health(amount: int) -> void:
	max_hp += amount

func die() -> void:
	pass
