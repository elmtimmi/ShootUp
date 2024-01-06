extends CharacterBody2D

@onready var joystick = $"../HUD/Joystick"


### Variables

# map boundaries
var tilesize = 16
var map_min_x = -32 * tilesize
var map_max_x = 96 * tilesize - 7 * tilesize
var map_min_y = -48 * tilesize + 1 * tilesize
var map_max_y = 80 * tilesize - 5 * tilesize

var speed = 300.0
var enemy_in_attack_range = false
var player_health_max = 10
var player_health
var player_alive = true


func _ready():
	player_health = player_health_max

func _physics_process(delta):
	var direction = joystick.posVector
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2(0, 0)

	move_and_slide()

	# Clamp position within map boundaries
	position.x = clamp(position.x, map_min_x, map_max_x)
	position.y = clamp(position.y, map_min_y, map_max_y)
	
	update_health_display()
	
	# enemy attack
	if player_health <= 0:
		player_alive = false
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		
		
### Attack Logic ###
func _on_attacking_player(damage):
	# Handle the enemy attack
	#print(damage)
	#print("Player is being attacked, message from player.gd")
	player_health -= damage
	print("Player health: " + str(player_health))
	
func update_health_display():
	var health_label = get_node("/root/World/HUD/HealthStatusLabel")  # Adjust the path to your label
	health_label.text = "Health: " + str(player_health) + "/" + str(player_health_max)


func player():
	pass

