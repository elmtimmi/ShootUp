extends CharacterBody2D

# Variables
var speed = 200
var Player
var attack_cooldown = 1
var can_attack = true
var in_attack_range = false
var damage = 1

# Signales
signal attacking_player(damage)


func set_player(player_node):
	Player = player_node

func _physics_process(delta):
	var direction = (Player.global_position - global_position).normalized()
	position += direction * speed * delta
	attack_player()
	# if the enemys should not be able to stack over each other use:
	# move_and_slide()



### Attack logic ###
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
		emit_signal("attacking_player", damage)
		can_attack = false
		$AttackCooldownTimer.wait_time = attack_cooldown
		$AttackCooldownTimer.start()

func _on_attack_cooldown_timer_timeout():
	can_attack = true

