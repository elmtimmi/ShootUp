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
var player_health_max = 10
var player_health
var player_alive = true
var player_attack_cooldown = 2
var player_can_attack = true
var enemy_in_attack_range = false
var player_damage = 5
var enemy_damage

# Signals
signal attacking_enemy(damage, attack_area)


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
	
	# Label updates
	update_health_display()
	update_money_display()
	
	# enemy attack
	if player_health <= 0:
		player_alive = false
		Global.money = 0
		Global.round_counter = 0
		Global.backpack =  []
		Global.player_attributes = {}
		
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
	# attack enemy
	attack_enemy()
		
		
### Attack Logic ###

## Enemy Attack
func _on_attacking_player(enemy_damage):
	# Handle the enemy attack
	#print(damage)
	#print("Player is being attacked, message from player.gd")
	player_health -= enemy_damage
	print("Player health: " + str(player_health))
	
func update_health_display():
	var health_label = get_node("/root/World/HUD/HealthStatusLabel")  # Adjust the path to your label
	health_label.text = "Health: " + str(player_health) + "/" + str(player_health_max)


func player():
	pass


## Player Attack
func _on_player_range_body_entered(body):
	print("something entered players range")
	if body.has_method("enemy"):
		print("an enemy entered players range")
		enemy_in_attack_range = true


func _on_player_range_body_exited(body):
	if body.has_method("enemy"):
		print("enemy exits")
		enemy_in_attack_range = false

	
func attack_enemy(): 
	if player_can_attack and enemy_in_attack_range:
		# Perform attack
		print("Player attacks")
		emit_signal("attacking_enemy", player_damage, $PlayerRange)
		player_can_attack = false
		$AttackCooldownTimer.wait_time = player_attack_cooldown
		$AttackCooldownTimer.start()


func _on_attack_cooldown_timer_timeout():
	player_can_attack = true


### Collect money
func _on_collect_range_body_entered(body):
	if body.has_method("money"):
		body.in_range_of_player = true
		body.player_pos = global_position
		#body.queue_free()
		
func update_money_display():
	var money_label = get_node("/root/World/HUD/MoneyLabel")  # Adjust the path to your label
	money_label.text = "Money: " + str(Global.money)
