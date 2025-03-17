extends Node

@onready var game_scene = load("res://Scenes/game_scene.tscn")
@onready var credits = $Credits
var game : Node

func _input(event):
	if credits.visible == true && \
		(event.is_action_pressed("ui_cancel") \
		|| event.is_action_released("attack_2")):
		credits.visible = false

func _on_start_pressed():
	game = game_scene.instantiate()
	game.ready.connect(retire)
	var tree : SceneTree = get_tree() as SceneTree
	var current_scene = tree.current_scene
	tree.root.add_child(game)
	tree.root.remove_child(current_scene)
	tree.current_scene = game

func retire():
	game.ready.disconnect(retire)
	queue_free()

func _on_credits_pressed():
	credits.visible = true
