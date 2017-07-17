extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar" 
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	
	get_node("Output").add_text("Hello world!")
	var card = load("res://Deck/Card_Missle.tscn")
	var card_inst = card.instance()
	card_inst.set_name("card")
	#add_child(card_inst)
	get_node("Card1").add_child(card_inst)
	card_inst.play()
	
	card_inst = load("res://Deck/Card_Wall.tscn").instance()
	card_inst.set_name("card")
	card_inst = get_node("Card2").add_child(card_inst)
	
	get_node("Card2").add_child(card_inst)
	
	set_process( true)
	set_process_input(true)

var curr_card = 1
var hand_size = 5
func _input(event):
	if event.type == InputEvent.KEY:
		if (event.is_action_released("ui_right")):
			is_right_down = false
		if (event.is_action_released("ui_left")):
			is_left_down  = false
		
			# Hand size
			
        # The 'W' key was released
var is_right_down = false
var is_left_down =  false

func _process(delta):
	if(Input.is_action_pressed("ui_right") and not is_right_down):
		print("Right")
		is_right_down = true
		curr_card = (curr_card + 1) % 5
		
	if(Input.is_action_pressed("ui_left") and not is_left_down):
		print("Left")
		is_left_down = true
		curr_card = abs((curr_card - 1 ) % 5)
		# Does weird stuff with modulo
		print("val:",curr_card)
	print(curr_card)
	
	var card = get_node("Card"+str((curr_card + 1)))
	var card_inst = card.get_node("card")
	
	if(card_inst != null):
		print(card_inst.description)
		get_node("Output").clear()
		get_node("Output").add_text(card_inst.description)
		
	var outline = get_node("Outline")
	var outline_new_x = card.get_pos().x 
	outline.set_pos(Vector2(outline_new_x - 2, outline.get_pos().y))
	
	print(curr_card)
	
	
		
	pass
	
