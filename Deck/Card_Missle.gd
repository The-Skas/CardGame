extends "res://Deck/Card.gd"

# class member variables go here, for example:


func _ready():
	self.cost = 2
	self.description = "This card shoots out a missle"
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	pass

func play():
	#Do something here when playedÍ
	var projectile = load("res://Projectile.tscn")
	var proj_inst  = projectile.instance()
	add_child(proj_inst)
