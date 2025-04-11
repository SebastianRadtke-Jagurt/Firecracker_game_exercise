extends Node
class_name WaveManager

@export var waves : Array[EnemyWave]
@export var game : Game

var current_wave : int = 0

var enemies : int = 0

func _ready():
	await get_tree().process_frame 
	while GameManager.game_parent == null:
		await get_tree().process_frame 
	spawn_wave()
	pass

func spawn_wave():
	if current_wave < waves.size():
		print("Spawn wave #", current_wave + 1)
		waves[current_wave].spawn_wave(self)
		current_wave += 1
	else:
		game.on_win()

func on_enemy_spawn():
	enemies += 1

func on_enemy_death():
	enemies -= 1
	if enemies <= 0:
		spawn_wave()
