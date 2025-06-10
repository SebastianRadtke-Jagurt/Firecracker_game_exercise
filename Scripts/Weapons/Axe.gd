extends Weapon
class_name Axe

@export var berserk_buff_applier : BuffApplier

enum ULTIMATE_STATE { SWINGING, SLAM }

func ultimiate_enter():
	berserk_buff_applier.apply()

func ultmiate_execute(delta):
	pass

func ultimate_exit():
	pass
