extends Node2D

@onready var player = $Player
@onready var anim = $AnimationPlayer

var rock_value
var rock_num 
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	player.parent = self
	GlobalVar.book_visible = true
	GlobalVar.subtraction = true
	GlobalVar.room = "underground"
	player.prep_cutscene()
	anim.play("start_scene")
	player.can_dash = GlobalVar.addition
	generate_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match rock_num:
		0:
			if $Barriers/Barrier1 != null:
				$Barriers/Barrier1/Label.visible = player.spell_book.visible
			pass
		1:
			if $Barriers/Barrier2 != null:
				$Barriers/Barrier2/Label.visible = player.spell_book.visible
			pass
		2:
			if $Barriers/Barrier3 != null:
				$Barriers/Barrier3/Label.visible = player.spell_book.visible
			pass

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_scene":
		player.fin_cutscene()
	
func generate_number():
	rock_value = rng.randi_range(-999,-1)
	player.needed_number = rock_value
	$Barriers/Barrier1/Label.text = str(rock_value)
	$Barriers/Barrier2/Label.text = str(rock_value)
	$Barriers/Barrier3/Label.text = str(rock_value)
	player.prep_starting_values()

func check_values():
	if player.calc_value == rock_value:
		match rock_num:
			0:
				$Barriers/Barrier1.queue_free()
				
				pass
			1:
				$Barriers/Barrier2.queue_free()
				pass
			2:
				$Barriers/Barrier3.queue_free()
				pass
		player.book_closed()
		player.spell_book._on_clear_button_down()
		generate_number()
	else:
		player.wrong()
		generate_number()


func _on_interact_body_entered(body):
	if body.name == "Player":
		rock_num = 0


func _on_interact2_body_entered(body):
	if body.name == "Player":
		rock_num = 1


func _on_interact3_body_entered(body):
	if body.name == "Player":
		rock_num = 2
