extends KinematicBody2D

#65 - 90: A - Z (Input is case INSENSITIVE)
var KEY_LETTERS = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
var KEY_CODES   = [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]

var key_index = 0
var last_key_index = 0

enum STATE {
	run,
	trip,
	jump,
	air
}

#Player Consts
const VEL_JUMP = Vector2(0.0, -220.0)
const FRIC = 0.95
const VEL_GRAVITY = Vector2(0.0, 13.0)
const JUMP_LIMIT = 0.20
const AIR_LIMIT  = 0.1

#Player variables
var state;
var vel = Vector2(0.0,0.0)
var jump_timer = 0.0
var time_in_air = 0.0
var mod = 0
onready var ray_ground = get_node("Ray_Ground")
onready var ray_forward = get_node("Ray_Collide")
onready var game = get_node("/root/Game")
onready var jumpkey_ex = get_node("JumpKey")
#onready var scrabble =   game.get_node("Scrabble")
var jumpkey
onready var tween = get_node("Tween")

func modifier(_mod):
	if _mod == 0: # no mod
		return true
	elif _mod == 1 and Input.is_key_pressed(KEY_SHIFT): # shift
		return true
	elif _mod == 2 and Input.is_key_pressed(KEY_CONTROL): # control
		return true
	else:
		return false

func get_random_key():
	mod = get_modifier()
	return randi()%KEY_LETTERS.size()

func get_modifier():
	if game != null:
		if game.score > game.MOD_TIME:
			var chance = randi()%10
			if chance >= 8:
				return 1
			elif chance >= 6:
				return 2
	return 0

func show_jumpkey():
	if jumpkey_ex != null:
		if jumpkey == null and not game.paused:
			jumpkey = jumpkey_ex.duplicate()
			add_child(jumpkey)
			tween.interpolate_property(jumpkey, "transform/pos", jumpkey_ex.get_pos() + Vector2(24, 0), jumpkey_ex.get_pos(), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(jumpkey, "transform/scale", Vector2(0.2, 0.2), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(jumpkey, "visibility/opacity", 0.5, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			jumpkey.show()
		elif jumpkey != null and not game.paused:
			var jumpkey2 = jumpkey_ex.duplicate()
			add_child(jumpkey2)
			tween.interpolate_property(jumpkey2, "transform/pos", jumpkey_ex.get_pos() + Vector2(24, 0), jumpkey_ex.get_pos(), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(jumpkey2, "transform/scale", Vector2(0.2, 0.2), Vector2(1,1), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.interpolate_property(jumpkey2, "visibility/opacity", 0.2, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
			jumpkey2.show()
			jumpkey.destroy()
			jumpkey = jumpkey2
			
func on_hit_box():
	get_node("SamplePlayer").play("slow")
	pass
	
func _ready():
	if jumpkey != null:
		jumpkey.hide()
	set_fixed_process(true)

	state = STATE.run

func _fixed_process(delta):
	if get_node("/root/Game") != null:
		if get_node("/root/Game").paused:
			return
		elif get_pos().y >= 16*11 or get_pos().x < 0: # Dead
			# Go to leaderboard
			get_node("/root/Game").die()
		elif ray_forward.is_colliding():
			get_node("/root/Game").die()
	
	move(vel * delta)
	
	#bounces player down if roof hit
	if vel.y < 0 and get_pos().y <= 0:
		vel.y = -vel.y*0.19
		state = STATE.air
	
	if state == STATE.jump:
		vel.y = VEL_JUMP.y
		if jump_timer > JUMP_LIMIT:
			state = STATE.air
		elif not Input.is_key_pressed(KEY_CODES[last_key_index]):
			state = STATE.air			
		jump_timer += delta
	elif Input.is_key_pressed(KEY_CODES[key_index]) and modifier(mod) and state == STATE.run:
		state = STATE.jump
		last_key_index = key_index
		key_index = get_random_key()
		show_jumpkey()
		jump_timer = 0
		play_jump_sound()
		#scrabble.add(KEY_LETTERS[last_key_index])
	elif ray_ground.is_colliding():
		state = STATE.run
		vel.y = 0
	elif not ray_ground.is_colliding():
		# prevent jump again via State management and ray to detect ground
		vel.y += VEL_GRAVITY.y
		state = STATE.air
		
	#update render:
	#get_node("JumpKey/Label").set_text(KEY_LETTERS[key_index])
	if mod == 1:
		get_node("Ctrl").hide()
		get_node("Shift").show()
	elif mod == 2:
		get_node("Ctrl").show()
		get_node("Shift").hide()
	else:
		get_node("Ctrl").hide()
		get_node("Shift").hide()
		
func play_jump_sound():
	var jumps = ["jump1", "jump2","jump3"]
	var i = randi()%jumps.size() 
	get_node("SamplePlayer").play(jumps[i])
	pass