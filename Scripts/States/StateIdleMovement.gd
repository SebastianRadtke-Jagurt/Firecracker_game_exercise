extends State
class_name StateIdleMovement

func enter():
	self.actor.set__can_get_hit(true)
	self.actor.play_animation("idle")

func execute(_delta):
	if(actor.movement_input != Vector2.ZERO):
		exit("moving")
		return
