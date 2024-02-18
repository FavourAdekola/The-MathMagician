extends Node2D

@onready var player = $Entities/Player
var slime_value = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_number()
	player.prep_cutscene()
	$AnimationPlayer.play("start_scene")
	GlobalVar.book_visible = true
	GlobalVar.addition = true
	player.parent = self
	GlobalVar.room = "exit hall"
	player.can_dash = GlobalVar.addition


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
		
func check_values():
	if player.calc_value == slime_value:
		player.prep_cutscene()
	else:
		player.wrong()
		generate_number()
		
func generate_number():
	player.needed_number = slime_value
	player.prep_starting_values()


func _on_animation_player_animation_started(anim_name):
	if anim_name == "start_scene":
		player.fin_cutscene()
		
	
