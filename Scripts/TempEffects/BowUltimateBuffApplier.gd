extends BuffApplier

func init(_actor : Actor):
	actor = _actor
	buff_to_apply.init(actor, self)

func apply():
	buff_apply_cooldown = buff_apply_cooldown_max
	var new_buff : Buff = buff_to_apply.duplicate()
	new_buff.init(actor, self)
	add_child(new_buff)
	new_buff.apply()
	buffs_applied.append(new_buff)

func expire(_buff : Buff):
	var buff : Buff = buffs_applied.pop_front()
	buff.expire()
