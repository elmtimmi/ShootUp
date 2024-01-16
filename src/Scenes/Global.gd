extends Node2D

### Variables
var money = 0
var round_counter = 0
var backpack = []

class Item:
	var id: int
	var title: String
	var description: String
	var cost: int
	
	func _init(_id, _title, _description, _cost):
		id = _id
		title = _title
		description = _description
		cost = _cost

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
