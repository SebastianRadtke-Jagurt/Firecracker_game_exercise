extends Buff

@export var mod_movement_speed : float = 1

func init(_actor : Actor, _buff_applier : BuffApplier): 
	super.init(_actor, _buff_applier)

func apply():
	actor.mod_movement_speed += mod_movement_speed

func _physics_process(delta):
	if expiration_time > 0:
		expiration_time -= delta
		if expiration_time <= 0:
			expire()

func expire():
	actor.mod_movement_speed -= mod_movement_speed
	queue_free()
