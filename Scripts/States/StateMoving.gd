extends State
class_name StateMoving

func enter():
	self.actor.set__can_get_hit(true)
	self.actor.play_animation("moving")

func execute(_delta):
	if(actor.movement_input != Vector2.ZERO):
		actor.movement_vector += actor.movement_input
	else:
		exit("idle")
		return
