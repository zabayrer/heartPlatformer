extends Node2D

@onready var level_complete = $Node/LevelComplete

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.level_complete.connect(show_level_complete)
	
func show_level_complete():
	level_complete.show()
	get_tree().paused = true
