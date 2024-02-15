extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var dash_time = $DashTimer
@onready var dash_dur = $DashLength
@onready var collision = $CollisionShape2D
@onready var book = $CanvasLayer/BookIcon
@onready var spell_book = $CanvasLayer/OpenBook
@onready var rng = RandomNumberGenerator.new()
@onready var camera = $Camera2D
@onready var parent

const GRAVITY  = 1000.0

@export var direction = Vector2.ZERO
@export var checkpoint = Vector2.ZERO
var dash_dir = Vector2(1,0)
var SPEED = 200.0
var JUMP_VELOCITY = -400.0
var DASH_SPEED = 1000.0

var calc_value
var starting_number
var needed_number = 1


@export var can_dash = false
var grounded = true
var jumping = false
var jump_position = 0
var dashing = false
var can_move = true
var can_activate_book = false
var in_pit = false


# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready():
	spell_book.player = self

func _physics_process(delta):
	update_book()
	if can_move:
		$Camera2D.position = 100*direction.normalized()
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
	if can_move:
		move_and_slide()


func _on_dash_timer_timeout():
	can_dash = true
	pass


func _on_dash_length_timeout():
	dashing = false
	dash_time.start()
	
func prep_cutscene():
	can_move = false
	velocity = Vector2.ZERO
	collision.disabled = true

func fin_cutscene():
	can_move = true
	collision.disabled = false
	
func update_book():
	if GlobalVar.room == "city maze":
		GlobalVar.book_visible = true
	
	book.visible = GlobalVar.book_visible
	book.disabled = !GlobalVar.book_visible
	
func respawn():
	global_position = checkpoint

func _on_book_icon_button_down():
	GlobalVar.book_visible = false
	spell_book.visible = true
	camera.position = Vector2(0,70)
	prep_cutscene()
	
func book_closed():
	GlobalVar.book_visible = true
	spell_book._on_clear_button_down()
	spell_book.visible = false
	fin_cutscene()
	
func activate_item(item_name):
	get_parent().activate_item(item_name)

func check_value():
	spell_book.equation.text = ""
	spell_book.first_number = []
	parent.check_values()

func prep_starting_values():
	if GlobalVar.room == "king castle" or GlobalVar.room == "underground":
		if needed_number > 0:
			starting_number = rng.randi_range(0,needed_number)
		else:
			starting_number = rng.randi_range(needed_number, -needed_number)
	elif GlobalVar.room == "city maze":
		starting_number = 1
	spell_book.prep_operations()

func wrong():
	$AnimationPlayer.play("wrong")
