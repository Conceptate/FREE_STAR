extends KinematicBody2D

var input_direction = 0
 
var speed = Vector2()
var velocity = Vector2()

var walking = false
var movement_state = false

const WALK_SPEED = 150
const RUN_SPEED = 325

const JUMP_FORCE = 700
const GRAVITY = 2000

const MAX_JUMP_COUNT = 2

var jump_count = 0
 
var sprite_node
 
func _ready():
	set_process(true)
	set_process_input(true)
	sprite_node = get_node("Sprite")

# Jumping
func _input(event):
	# BUG: is_action_pressed() doesnt work when you're walking
	if (event.is_action_pressed("jump") and jump_count < MAX_JUMP_COUNT):
		print("yeet")
		speed.y = -JUMP_FORCE
		jump_count += 1
	pass

# on every frame...
func _process(delta):
	# Reset the walk variable
	walking = false
	
	# If the walk key is held, set the walk variable back to true
#	if Input.is_action_pressed(KEY_SHIFT):
	if Input.is_action_pressed("walk"):
		walking = true
		print("Call 3")
#		print("i work fine")
	
	# If walking left or right, set those variables
	if Input.is_action_pressed("move_left"):
		input_direction = -1
		sprite_node.set_flip_h(true)
	elif Input.is_action_pressed("move_right"):
		input_direction = 1
		sprite_node.set_flip_h(false)
	else:
		input_direction = 0
	
	if (input_direction):
		if (walking):
			if (input_direction == -1):
				speed.x = WALK_SPEED
				movement_state = true
				print("walking left")
			elif (input_direction == 1):
				speed.x = WALK_SPEED
				movement_state = true
				print("walking right")
		else:
			if (input_direction == -1):
				speed.x = RUN_SPEED
				movement_state = false
				print("running left")
			elif (input_direction == 1):
				speed.x = RUN_SPEED
				movement_state = false
				print("running right")
	else:
		speed.x = 0
		movement_state = false
	if (movement_state):
		speed.x = clamp(speed.x, 0, WALK_SPEED)
#		print("walking clamp")
	else:
		speed.x = clamp(speed.x, 0, RUN_SPEED)
#		print("running clamp")
	
	speed.y += GRAVITY * delta
	
	velocity = Vector2(speed.x * delta * input_direction, speed.y * delta)
	var movement_remainder = move(velocity)
	
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		jump_count = 0
		speed = normal.slide(speed)
		move(final_movement)