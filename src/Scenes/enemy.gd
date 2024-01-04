extends CharacterBody2D

# Variables
var speed = 200
var Player

func set_player(player_node):
	Player = player_node

func _physics_process(delta):
	var direction = (Player.global_position - global_position).normalized()
	position += direction * speed * delta
