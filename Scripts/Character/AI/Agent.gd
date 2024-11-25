## AI component that assists with things.
class_name Agent extends Node

## The raycast used for line of sight checks.
@export var los_ray: RayCast3D
@export var skin_handler: SkinHandler
@export var mover: AIMover

## Is the line of sight valid?
func is_los_valid(target_char: CharacterBody3D) -> bool:
	# Handle the line of sight check
	los_ray.look_at_from_position(
		los_ray.global_position,
		target_char.global_position + Vector3.UP
	)
	los_ray.force_raycast_update()
	if los_ray.is_colliding() == true:
		var collider = los_ray.get_collider()
		if collider == target_char:
			return true
	
	return false
