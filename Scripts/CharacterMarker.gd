extends CharacterBody2D

@onready var player = get_parent().get_node("Player")

const FRICTION = 10.0
const GRAVITY  = 300.0

var direction = Vector2.ZERO
var SPEED = 200.0
var JUMP_VELOCITY = -400.0


func _physics_process(delta):
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	
	
	if direction != Vector2.ZERO:
		velocity = direction.normalized() * SPEED
	
	if global_position.y <= player.global_position.y :
		player.grounded = true
		player.jumping = false
		player.global_position.y = global_position.y
	
	if direction == Vector2.ZERO:
		if not player.jumping:
			velocity = Vector2.ZERO
		else:
			velocity.x = 0
		
	move_and_slide()
