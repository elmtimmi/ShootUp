extends Node2D


### Variables
# Scenes
var enemy_scene = preload("res://Scenes/enemy.tscn")
var enemy_damage

# map boundaries
var tilesize = 16
var map_min_x = -32 * tilesize
var map_max_x = 96 * tilesize - 7 * tilesize
var map_min_y = -48 * tilesize + 1 * tilesize
var map_max_y = 80 * tilesize - 5 * tilesize

# Game variables
var rounds = 0
var timer_time = 2.0  # Initial timer time
var minimum_time = 0.5  # Minimum timer time



func spawn_enemy(pos):
	var enemy_instance = enemy_scene.instantiate()
	enemy_instance.set_player($Player)
	enemy_instance.position = pos
	add_child(enemy_instance)
	
	enemy_instance.connect("attacking_player", Callable($Player, "_on_attacking_player"))
	# To debug the connection:
	#var connection_result = enemy_instance.connect("attacking_player", Callable($Player, "_on_attacking_player"))
	#if connection_result == OK:
	#	print("Signal successfully connected.")
	#else:
	#	print("Signal connection failed. Error: ", connection_result)


func random_pos_on_map():
	var random_x = randf_range(map_min_x, map_max_x)
	var random_y = randf_range(map_min_y, map_max_y)
	var random_position = Vector2(random_x, random_y)
	return random_position
	
	
func _ready():
	# Spawn 2 enemies to begin with
	spawn_enemy(Vector2(50,50))
	spawn_enemy(random_pos_on_map())
	# initilize the timers
	var round_timer = $Timers/RoundTimer
	round_timer.start()
	var spawn_timer = $Timers/EnemySpawnTimer  # Adjust the path to match your Timer node
	spawn_timer.wait_time = timer_time
	# Update the label every frame
	var timer_label_path = $HUD/RoundTimerDisplay  # Path to the Label node
	timer_label_path.text = str(int(round_timer.wait_time))
	
	
func _process(delta):
	var round_timer = $Timers/RoundTimer
	var time_left = round_timer.time_left
	var timer_label_path = $HUD/RoundTimerDisplay  # Path to the Label node
	timer_label_path.text = str(int(time_left))


func _on_enemy_spawn_timer_timeout():
	spawn_enemy(random_pos_on_map())
	# Decrease timer time and clamp to minimum value
	timer_time = max(timer_time - 0.1, minimum_time)
	$Timers/EnemySpawnTimer.wait_time = timer_time


func _on_round_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
