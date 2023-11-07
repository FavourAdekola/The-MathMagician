extends CharacterBody2D

@onready var sprite = $Sprite2D

const GRAVITY  = 1000.0

var direction = Vector2.ZERO
var SPEED = 200.0
var JUMP_VELOCITY = -400.0


var grounded = true
var jumping = false
var jump_position = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.


func _physics_process(delta):
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	# Add the gravity.
	
	
	if not grounded:
		jump_position += GRAVITY * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and grounded:
		jump_position = global_position
		jump_position = JUMP_VELOCITY
		grounded = false
		jumping = true
		print(velocity.y)
	
	velocity = direction.normalized() * SPEED
		
	velocity.y += jump_position
	move_and_slide()
