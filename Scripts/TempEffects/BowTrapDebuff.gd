extends Buff

func apply_to(actor : Actor):
	self.actor = actor
	actor.mod_movement_speed -= 0.6
	actor.on_get_hit_check.connect(trap_mark_damage)
	# TODO - pass timeout time
	get_tree().create_timer(5).timeout.connect(expire)

func trap_mark_damage():
	# TODO - pass damage
	if actor.on_get_hit_check.is_connected(trap_mark_damage):
		actor.on_get_hit_check.disconnect(trap_mark_damage)
	expire()
	actor.get_hit(5, 0, 0, Vector2.ZERO, null)

func expire():
	actor.mod_movement_speed += 0.6
	queue_free()
