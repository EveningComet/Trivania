## A bar that displays a vital component of a character, such as HP.
class_name Vitalbar extends ProgressBar

var _damageable: Damageable

func set_monitorable(new_monitorable: Damageable) -> void:
	_damageable = new_monitorable
	_damageable.hp_changed.connect( _on_hp_changed )
	_on_hp_changed(_damageable.curr_hp, _damageable.max_hp)

func _on_hp_changed(curr_value: int, new_max_value: int) -> void:
	value = curr_value
	max_value = new_max_value
