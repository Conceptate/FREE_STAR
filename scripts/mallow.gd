extends KinematicBody2D

var input_direction = 0
 
var speed = Vector2()
var velocity = Vector2()

var walk_speed = 150
var run_speed = 325
var walking = false
var movement_state = false

const JUMP_FORCE = 700
const GRAVITY = 2000

const MAX_JUMP_COUNT = 2

var jump_count = 0
 
var sprite_node
 
func _ready():
	set_process(true)
	set_process_input(true)
	sprite_node = get_node("Sprite")
 
 
func _input(event):
	if jump_count < MAX_JUMP_COUNT and event.is_action_pressed("jump"):
		speed.y = -JUMP_FORCE
		jump_count += 1
 
# on every frame...
func _process(delta):
	# Reset the walk variable
	walking = false
	
	# If the walk key is held, set the walk variable back to true
#	if Input.is_action_pressed(KEY_SHIFT):
	if Input.is_action_pressed("walk"):
		walking = true
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
				speed.x = walk_speed
				movement_state = true
				print("walking left")
			elif (input_direction == 1):
				speed.x = walk_speed
				movement_state = true
				print("walking right")
		else:
			if (input_direction == -1):
				speed.x = run_speed
				movement_state = false
				print("running left")
			elif (input_direction == 1):
				speed.x = run_speed
				movement_state = false
				print("running right")
	else:
		speed.x = 0
		movement_state = false
	if (movement_state):
		speed.x = clamp(speed.x, 0, walk_speed)
		print("walking clamp")
	else:
		speed.x = clamp(speed.x, 0, run_speed)
		print("running clamp")
	
	speed.y += GRAVITY * delta
	
	print(jump_count)
	velocity = Vector2(speed.x * delta * input_direction, speed.y * delta)
	var movement_remainder = move(velocity)
	
	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		jump_count = 0
		speed = normal.slide(speed)
		move(final_movement)