extends Node2D

@onready var player = $Player
@onready var anim = $AnimationPlayer
@onready var rng = RandomNumberGenerator.new()

var wizard_health = 3
var wizard_value

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.room = "king castle"
	player.can_dash = GlobalVar.addition
	player.prep_cutscene()
	anim.play("start_scene")
	generate_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !player.dashing and player.in_pit:
		player.respawn()

func _on_checkpoint_body_entered(body):
	if body.name == "Player":
		player.checkpoint = player.global_position


func _on_fall_pit_body_entered(body):
	if body.name == "Player":
		player.in_pit = true

func _on_fall_pit_body_exit(body):
	if body.name == "Player":
		player.in_pit = false


func _on_exit_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/City_Maze.tscn")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_scene":
		anim.play("begin dialogue")
	elif anim_name == "begin dialogue":
		anim.play("Wizard Entrance")
	elif anim_name == "Wizard Entrance":
		$BackDrop.visible = true
		player._on_book_icon_button_down()
	elif anim_name == "end fight":
		anim.play("end dialogue")
	elif anim_name == "end dialogue":
		GlobalVar.subtraction = true
		anim.play("exit_scene")
	elif anim_name == "exit_scene":
		get_tree().change_scene_to_file("res://Scenes/City_Maze.tscn")
		
		
func start_dialogue():
	pass

func check_values():
	if player.calc_value == wizard_value:
		wizard_health -= 1
		generate_number()
	else:
		get_tree().reload_current_scene()
	if wizard_health == 0:
		end_fight()
		
func generate_number():
	wizard_value = rng.randi_range(0,9999)
	$BackDrop/Value_Label.text = str(wizard_value)
	player.needed_number = wizard_value
	player.prep_starting_values()
	
func end_fight():
	anim.play("end fight")
