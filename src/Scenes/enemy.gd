extends CharacterBody2D

# Variables
var speed = 200
var Player
var attack_cooldown = 1
var can_attack = true
var in_attack_range = false
var enemy_damage = 1
var enemy_health = 5
var player_in_this_enemys_hitbox = false

# Signales
signal attacking_player(damage)
signal enemy_died(global_position)


func set_player(player_node):
	Player = player_node

func _physics_process(delta):
	var direction = (Player.global_position - global_position).normalized()
	position += direction * speed * delta
	attack_player()
	if enemy_health <= 0:
		emit_signal("enemy_died", global_position)
		queue_free()  # Removes the enemy from the scene
		
	# if the enemys should not be able to stack over each other use:
	# move_and_slide()



### Attack logic ###

## Enemy attacks Player
func enemy():
	# for detection if the enemy is in attack range
	pass
	# in player script check if the body that enters the hitbox has the function enemy
	
func _on_enemy_range_body_entered(body):
	if body.has_method("player"):
		in_attack_range = true
		
func _on_enemy_range_body_exited(body):
	if body.has_method("player"):
		in_attack_range = false
	
func attack_player():
	if can_attack and in_attack_range:
		# Perform attack
		print("Enemy attacks")
		emit_signal("attacking_player", enemy_damage)
		can_attack = false
		$AttackCooldownTimer.wait_time = attack_cooldown
		$AttackCooldownTimer.start()

func _on_attack_cooldown_timer_timeout():
	can_attack = true


## Player attacks enemy
func _on_attacking_enemy(player_damage, attack_area):
	# Handle the player attack
	#print(player_damage)
	print("Player attacked, message from enemy.gd")
	var hitbox_area = $EnemyHitbox

		
	if hitbox_area:
		# Node was successfully found
		print("Hitbox area found: ", hitbox_area)
		if attack_area.overlaps_area(hitbox_area):
			enemy_health -= player_damage
	else:
		# Node was not found
		print("Hitbox area not found.")
	

