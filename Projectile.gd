extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var pos = Vector2( 20, 20)
var vel = Vector2( 0 , -50)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	
func _process(delta):
	pos = self.get_global_pos()
	self.move_to( pos + vel * delta)
