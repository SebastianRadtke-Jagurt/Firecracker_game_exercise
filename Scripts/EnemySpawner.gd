extends Node2D
class_name EnemySpawner

@export_enum("ARROW", "GRUNT", "RANGER", "VETERAN", "ELITE") var enemy_to_spawn : String

var enemy : Enemy

func spawn(wave_manager : WaveManager):
	enemy = GameManager.Instantiate(enemy_to_spawn) as Enemy
	print("Spawning, ", enemy_to_spawn , " - ", enemy)
	GameManager.game_parent.add_child.call_deferred(enemy)
	enemy.global_position = global_position
	wave_manager.on_enemy_spawn()
	enemy.on_death.connect(wave_manager.on_enemy_death)
