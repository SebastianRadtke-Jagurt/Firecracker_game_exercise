extends Node
class_name BuffApplier

var actor : Actor
@export var buff_to_apply : Buff
@export var buff_count_max : int = 1

var buff_apply_cooldown_max : float = 0.2
var buff_apply_cooldown : float = 0

var buffs_applied : Array[Buff]

func init(_actor : Actor):
	actor = _actor
	buff_to_apply.init(actor, self)

func connect_applier():
	pass

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
