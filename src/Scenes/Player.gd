extends CharacterBody2D

@onready var joystick = $"../HUD/Joystick"

# map boundaries
var tilesize = 16
var map_min_x = -32 * tilesize
var map_max_x = 96 * tilesize - 4 * tilesize
var map_min_y = -48 * tilesize + 1 * tilesize
var map_max_y = 80 * tilesize - 5 * tilesize

var speed = 300.0

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
