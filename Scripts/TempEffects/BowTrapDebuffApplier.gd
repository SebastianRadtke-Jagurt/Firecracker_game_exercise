extends BuffApplier

func apply_to(_actor : Actor):
	var new_buff = buff_to_apply.duplicate()
	add_child(new_buff)
	new_buff.apply_to(_actor)
