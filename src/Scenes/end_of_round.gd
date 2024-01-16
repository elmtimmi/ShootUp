extends Node2D

var selected_items

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.money += 50
	var title_label = $VFlowContainer/header/Label  # Path to the Label node
	
	title_label.text = "Wave " + str(Global.round_counter) + " "
	
	roll_items()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var money_label = $VFlowContainer/Profile/Money  # Path to the Label node
	money_label.text = str(Global.money) + "$"
	var stats_text = $VFlowContainer/playerStats/StatsText  # Path to the Label node
	var itemStringNameList = ""
	for i in range(Global.backpack.size()):
		if i == 0:
			itemStringNameList += Global.backpack[i].title
		else:
			itemStringNameList += ", " + Global.backpack[i].title
	
	stats_text.text = "Buyed Items (" + str(Global.backpack.size()) + "): " + itemStringNameList
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func roll_items():
	# load all poisible itmes
	var items = load_items_from_json("res://Assets/items.json")
	selected_items = get_random_items(items, 3)
	
	#Card 1
	var card1_title = $VFlowContainer/Card1/title
	card1_title.text = selected_items[0].title
	var card1_description = $VFlowContainer/Card1/description
	card1_description.text = selected_items[0].description
	var card1_cost = $VFlowContainer/Card1/cost
	card1_cost.text = str(selected_items[0].cost)
	
	#Card 2
	var card2_title = $VFlowContainer/Card2/title
	card2_title.text = selected_items[1].title
	var card2_description = $VFlowContainer/Card2/description
	card2_description.text = selected_items[1].description
	var card2_cost = $VFlowContainer/Card2/cost
	card2_cost.text = str(selected_items[1].cost)
	
	#Card 3
	var card3_title = $VFlowContainer/Card3/title
	card3_title.text = selected_items[2].title
	var card3_description = $VFlowContainer/Card3/description
	card3_description.text = selected_items[2].description
	var card3_cost = $VFlowContainer/Card3/cost
	card3_cost.text = str(selected_items[2].cost)
	
	for item in selected_items:
		print("ID: %d\nBeschreibung: %s\nKosten: %d" % [item.id, item.description, item.cost])


func load_items_from_json(file_path):
	var dataFile = FileAccess.open(file_path, FileAccess.READ)
	var items = []
	var json_data = dataFile.get_as_text()
	dataFile.close()

	var parsed_data = JSON.parse_string(json_data)
	for data in parsed_data:
		items.append(Global.Item.new(data["id"], data["title"], data["description"], data["cost"]))
	return items

func get_random_items(items, count):
	randomize()
	var selected = []
	while selected.size() < count and items.size() > 0:
		var random_index = randi() % items.size()
		selected.append(items[random_index])
		items.remove_at(random_index) # Aktualisierte Methode zum Entfernen eines Elements
	return selected
	
	


func _on_cost_button_up(cardIndex):
	var cost = selected_items[cardIndex - 1].cost
	if Global.money >= cost:
		Global.money -= cost
		hide_card(cardIndex)
		Global.backpack.append(selected_items[cardIndex - 1])
		

func hide_card(index):
	if index == 1:
		get_node("VFlowContainer/Card1").hide()
	if index == 2:
		get_node("VFlowContainer/Card2").hide()
	if index == 3:
		get_node("VFlowContainer/Card3").hide()


func _on_reroll_pressed():
	var cost = 20
	if Global.money >= cost:
		Global.money -= cost
		get_node("VFlowContainer/Card1").show()
		get_node("VFlowContainer/Card2").show()
		get_node("VFlowContainer/Card3").show()
		roll_items()
