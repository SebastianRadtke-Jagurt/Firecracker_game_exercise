extends EnemyWeapon

func shoot():
	var new_arrow = GameManager.arrow.instantiate()
	GameManager.game_parent.add_child(new_arrow)
	await get_tree().physics_frame
	(new_arrow as Projectile).global_position = offset.global_position
	(new_arrow as Projectile).shoot(Vector2.DOWN.rotated(offset.global_rotation), \
								buffered_attack, \
								actor.hurtbox_mask,
								3)
	pass

func set_active_hurtbox(_active : bool):
	pass
