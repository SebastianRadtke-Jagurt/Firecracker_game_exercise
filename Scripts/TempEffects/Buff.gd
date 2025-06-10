extends Node
class_name Buff

var actor : Actor
var buff_applier : BuffApplier

@export var expiration_time_max : float = 3
var expiration_time : float

func init(_actor : Actor, _buff_applier : BuffApplier):
	actor = _actor
	buff_applier = _buff_applier

func apply():
	pass

func _physics_process(delta):
	if expiration_time > 0:
		expiration_time -= delta
		if expiration_time <= 0:
			expire()

func expire():
	# Usually reverts buff efects,
	# destroy this instance buff instance
	# and delets this buff instance from applier's array
	buff_applier.expire(self)
	queue_free()
	pass
