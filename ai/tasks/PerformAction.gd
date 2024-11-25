## BT Task that makes an enemy perform a particular action.
extends BTAction

## Name of the animation to perform.
@export var anim_name_string: String = "attack"

func _tick(delta: float) -> Status:
	agent.skin_handler.animation_tree.set("parameters/%s/request" % [anim_name_string], AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	return SUCCESS
