## A component meant to be attached to objects that can take damage and die.
class_name Damageable extends Node

## Event that gets fired whenever the hp changes.
signal hp_changed(curr_value: int, max_value: int)

@export var max_hp: int = 50
var curr_hp:        int = 0:
	get: return curr_hp
	set(value):
		curr_hp = value
		if curr_hp > max_hp:
			curr_hp = max_hp

func _ready() -> void:
	curr_hp = max_hp

func take_damage(damage_data: int) -> void:
	curr_hp -= damage_data
	hp_changed.emit(curr_hp, max_hp)
	if curr_hp < 0:
		die()

func heal(amount: int) -> void:
	curr_hp += amount
	hp_changed.emit(curr_hp, max_hp)

func upgrade_health(amount: int) -> void:
	max_hp += amount
	hp_changed.emit(curr_hp, max_hp)

func die() -> void:
	if OS.is_debug_build() == true:
		print("Damageable :: %s is dying." % [get_parent().name])
	
	# TODO: More robust death handling.
	get_parent().queue_free()
