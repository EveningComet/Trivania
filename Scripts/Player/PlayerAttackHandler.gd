## Handles attacking for the player.
class_name PlayerAttackHandler extends Node

## The damage to deal.
@export var damage: int = 5

@export var hurtbox: Area3D

## Node to help with IK bones.
@export var ik_target: Node3D

@onready var _skin_handler:          SkinHandler = get_parent().get_node("SkinHandler")
@onready var _locomotion_controller: PlayerLocomotionController = get_parent().get_node("PlayerLocomotionController")

var _attacking: bool = false # TODO: Find a way to not have to use this.

var _attack_node_anim_request: String = "parameters/attack/request"

func _ready() -> void:
	hurtbox.body_entered.connect( _on_hurtbox_entered )

func _physics_process(delta: float) -> void:
	ik_target.position.z = 0.0
	
	_safety_check()
	if _may_attack() == true:
		if Input.is_action_just_pressed("attack"):
			_attacking = true
			_skin_handler.skeleton_ik.start()
			_skin_handler.animation_tree.set(
				_attack_node_anim_request,
				AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
			)

## Turn on the hurtbox so that things can be damaged.
func activate_hurtbox() -> void:
	hurtbox.monitoring = true

## Turn off the hurtbox.
func deactivate_hurtbox() -> void:
	hurtbox.monitoring = false
	_attacking = false
	_skin_handler.skeleton_ik.stop()

func _on_hurtbox_entered(body) -> void:
	# Don't hurt self
	if body == get_parent():
		return
	
	# TODO: For greater accuracy, check for the thing's hitboxes.
	if body.has_node("Damageable"):
		var damageable: Damageable = body.get_node("Damageable")
		body.damageable.take_damage(damage)

## Used to disable the attack animation and hurtbox.
func _safety_check() -> void:
	if _skin_handler.animation_tree["parameters/attack/active"] == false \
		or _locomotion_controller.curr_state is PLLedgeGrab:
		_skin_handler.animation_tree.set(
			_attack_node_anim_request,
			AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
		)
		_skin_handler.skeleton_ik.stop()
		deactivate_hurtbox()

## A safety check that
func _may_attack() -> bool:
	return _attacking == false \
	and _locomotion_controller.curr_state is not PLLedgeGrab
