extends Buff
class_name DeflectBuff

@export var deflect_audio_player : AudioStreamPlayer2D

@export var buff_particle_parent : Node2D
var buff_particle : CPUParticles2D

@export var movement_speed : float
@export var attack_damage : int

func apply():
	expiration_time = expiration_time_max
	actor.mod_movement_speed += movement_speed
	actor.mod_attack_damage += attack_damage
	deflect_audio_player.play()
	actor.get_hit_cooldown = actor.get_hit_cooldown_max
	actor.on_get_hit.connect(expire)
	
	buff_particle = GameManager.deflect_buff_particles.instantiate()
	buff_particle_parent.add_child(buff_particle)
	buff_particle.init(buff_particle_parent.global_position)
	buff_particle.global_rotation = buff_particle_parent.global_rotation
	buff_particle.position.y -= 4

func _physics_process(delta):
	if expiration_time > 0:
		expiration_time -= delta
		if expiration_time <= 0:
			expire_deflect(0, 0, 0, Vector2.ZERO, null)

func expire_deflect(_damage : int, _stagger : int, _knockback : int, _attack_dir : Vector2, _attacker : Actor):
	buff_particle.queue_free()
	actor.on_get_hit.disconnect(expire)
	actor.mod_movement_speed -= movement_speed
	actor.mod_attack_damage -= attack_damage
	buff_applier.expire(self)
	queue_free()
