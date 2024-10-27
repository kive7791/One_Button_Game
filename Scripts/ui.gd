extends CanvasLayer

class_name ui 
signal game_start
var game_level = 0

@onready var end = $EndScreen

func _ready():
	pass
	

func update_level(level: int):
	game_level = level
	

func on_game_over():
	end.visible = true
	$EndScreen/Score/LevelReahced.text = '%d' % game_level

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
