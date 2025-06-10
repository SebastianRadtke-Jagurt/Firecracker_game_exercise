extends BuffApplier
class_name DeflectBuffApplier

@export var sword : Sword

func init(_actor : Actor):
	actor = _actor
	buff_to_apply.init(actor, self)
	sword.on_swap_in.connect(connect_applier)
	sword.on_swap_out.connect(disconnect_applier)

func connect_applier():
	actor.on_hit.connect(check_deflect)
	actor.on_weapon_clash.connect(check_deflect)

func disconnect_applier():
	actor.on_hit.disconnect(check_deflect)
	actor.on_weapon_clash.disconnect(check_deflect) 

func check_deflect(attacked : Actor):
	if attacked.events.has("take_deflect") && attacked.events["take_deflect"].check_deflect():
		var slash_vfx = GameManager.slash_vfx.instantiate()
		get_tree().root.add_child(slash_vfx)
		var dir =  actor.global_position.direction_to(attacked.global_position)
		slash_vfx.init(actor.global_position + dir * 36)
		apply()

func apply():
	buff_apply_cooldown = buff_apply_cooldown_max
	var new_buff = buff_to_apply.duplicate()
	add_child(new_buff)
	new_buff.apply()
	
	if buffs_applied.size() >= buff_count_max:
		buffs_applied.front().expire()
		buffs_applied.append(new_buff)

func expire(buff : Buff):
	buffs_applied.erase(buff)
