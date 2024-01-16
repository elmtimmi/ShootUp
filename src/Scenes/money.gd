extends CharacterBody2D

var speed = 500  # Adjust as needed
var in_range_of_player = false
var player_pos = Vector2()
var money_pos = Vector2()

func money():
	pass
	
func _physics_process(delta):
	if in_range_of_player:
		var direction = (player_pos - global_position).normalized()
		if direction:
			velocity = direction * speed
		else:
			velocity = Vector2(0, 0)
		move_and_slide()


func _on_collect_range_area_entered(area):
	if area.name == "PlayerHitbox":
		Global.money += 1
		queue_free()
