extends Control
class_name GameMenu

@export var menu : Control
@export var game : Game

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		menu.visible = !menu.visible
		game.pause(menu.visible)

func _on_resume_pressed():
	menu.visible = false
	game.pause(false)

func _on_restart_pressed():
	game.pause(false)
	game.restart()

func _on_exit_pressed():
	game.pause(false)
	game.return_to_main_menu()

func _on_menu_button_pressed():
	menu.visible = true
	game.pause(true)
