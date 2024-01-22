extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var dash_time = $DashTimer
@onready var dash_dur = $DashLength
@onready var collision = $CollisionShape2D
@onready var book = $CanvasLayer/BookIcon

const GRAVITY  = 1000.0

@export var direction = Vector2.ZERO
@export var checkpoint = Vector2.ZERO
var dash_dir = Vector2(1,0)
var SPEED = 200.0
var JUMP_VELOCITY = -400.0
var DASH_SPEED = 800.0


@export var can_dash = false
var grounded = true
var jumping = false
var jump_position = 0
var dashing = false
var can_move = true

# Get the gravity from the project settings to be synced with RigidBody nodes.


func _physics_process(delta):
	update_book()
	if can_move:
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction != Vector2.ZERO:
		dash_dir = direction
	
	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false
	# Add the gravity.
	
	
	#if not grounded:
	#	jump_position += GRAVITY * delta
	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and grounded:
#		jump_position = global_position
#		jump_position = JUMP_VELOCITY
#		grounded = false
#		jumping = true
#		print(velocity.y)

	if Input.is_action_just_pressed("dash") and can_dash:
		dashing = true
		can_dash = false
		dash_dur.start()
	
	if dashing:
		velocity = dash_dir.normalized() * DASH_SPEED
	else:
		velocity = direction.normalized() * SPEED
		
	velocity.y += jump_position
	move_and_slide()


func _on_dash_timer_timeout():
	can_dash = true
	pass


func _on_dash_length_timeout():
	dashing = false
	dash_time.start()
	
func prep_cutscene():
	can_move = false
	collision.disabled = true

func fin_cutscene():
	can_move = true
	collision.disabled = false
	
func update_book():
	book.visible = GlobalVar.book_visible
	book.disabled = !GlobalVar.book_visible
	
func respawn():
	global_position = checkpoint
	
