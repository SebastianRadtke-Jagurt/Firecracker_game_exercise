extends Node2D
class_name EnemyWave

@export var spawners : Array[EnemySpawner]

func spawn_wave(wave_manager : WaveManager):
	for spawner in spawners:
		spawner.spawn(wave_manager)
