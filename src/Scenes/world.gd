extends Node2D


# Assuming this code is in your main scene
var enemy_scene = preload("res://Scenes/enemy.tscn")


func spawn_enemy(pos):
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.set_player($Player)
	enemy_instance.position = pos
	add_child(enemy_instance)
	
func _process(delta):
	pass
	
func _ready():
	spawn_enemy(Vector2(50,50))
