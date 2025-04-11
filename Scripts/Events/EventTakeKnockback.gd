extends Event
class_name EventTakeKnockback

func init(_actor : Actor):
	super.init(_actor)
	actor.on_get_hit.connect(take_knockback)

func take_knockback(_damage : int, _stagger_score : int, knockback : int, direction : Vector2, _attacker : Actor):
	actor.knockback_vector += direction * knockback
