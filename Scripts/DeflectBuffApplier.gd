extends Node
class_name DeflectBuffApplier

@export var actor : Actor
@export var buff_to_apply : DeflectBuff
@export var buff_count_max : int = 1

var buff_apply_cooldown_max : float = 0.2
var buff_apply_cooldown : float = 0

var buffs_applied : Array[DeflectBuff]

func _ready():
	actor.on_hit.connect(check_deflect)
	actor.on_sword_clash.connect(check_deflect)

func check_deflect(attacked : Actor):
	if attacked.states.has("take_deflect") && attacked.states["take_deflect"].check_deflect():
		var slash = GameManager.slash.instantiate()
		get_tree().root.add_child(slash)
		var dir =  actor.global_position.direction_to(attacked.global_position)
		slash.init(actor.global_position + dir * 36)
		apply()

func apply():
	buff_apply_cooldown = buff_apply_cooldown_max
	var new_buff = buff_to_apply.duplicate()
	add_child(new_buff)
	new_buff.apply()
	
	if buffs_applied.size() >= buff_count_max:
		buffs_applied.front().expire()
		buffs_applied.append(new_buff)
	

func expire(buff : DeflectBuff):
	buffs_applied.erase(buff)
