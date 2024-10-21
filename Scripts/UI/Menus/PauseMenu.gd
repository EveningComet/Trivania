## Handles the pause menu.
class_name PauseMenu extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	
	# TODO: Find a better place to start playing the music.
	var audio: AudioStream = preload("res://Imported Assets/Audio/Audio/Music/Vindswept/Vindswept - Windswept Murmur.ogg")
	SoundManager.play_music_at_volume(audio, -20.0, 1.0, "Music")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_state   = not get_tree().paused
		get_tree().paused = pause_state
		visible           = pause_state
		
		if event.is_action_pressed("toggle_mouse"):
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
