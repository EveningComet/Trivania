## Handles attacking for the player.
class_name PlayerAttackHandler extends Node

@export var ik_target: Node3D

@onready var _skin_handler:          SkinHandler = get_parent().get_node("SkinHandler")
@onready var _locomotion_controller: PlayerLocomotionController = get_parent().get_node("PlayerLocomotionController")

var _attacking: bool = false # TODO: Find a way to not have to use this.

func _process(delta: float) -> void:
	ik_target.position.z = 0.0
	
	if _locomotion_controller.curr_state is PLLedgeGrab:
		_skin_handler.animation_tree.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT)
		_skin_handler.skeleton_ik.stop()
	
	if _attacking == false:
		if Input.is_action_just_pressed("attack") and _locomotion_controller.curr_state is not PLLedgeGrab:
			_attacking = true
			_skin_handler.skeleton_ik.start()
			_skin_handler.animation_tree.set("parameters/attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			await get_tree().create_timer(2.0, false, true).timeout
			_skin_handler.skeleton_ik.stop()
			_attacking = false
