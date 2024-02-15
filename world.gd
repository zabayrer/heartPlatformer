extends Node2D

@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
@onready var level_complete = $Node/LevelComplete

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	polygon_2d.polygon = collision_polygon_2d.polygon
	Events.level_complete.connect(show_level_complete)
	
func show_level_complete():
	level_complete.show()
	get_tree().paused = true
