extends CPUParticles2D

func init(pos : Vector2):
	global_position = pos
	await get_tree().physics_frame
	emitting = true

func _on_finished():
	queue_free()
