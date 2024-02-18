extends Node2D

@onready var player = $Player
@onready var rng = RandomNumberGenerator.new()

enum SYMBOL {NONE, PLUS, MINUS, MULTIPLY, DIVIDE}
var temp_save

var boss_value 
var boss_stage = 0
var timer = 30
var on_floor = true
# Called when the node enters the scene tree for the first time.
func _ready():
	player.prep_cutscene()
	if GlobalVar.room != "final room":
		$AnimationPlayer.play("start_scene")
	else:
		player.collision.disabled = true
		player.global_position = Vector2(1728,480)
		$AnimationPlayer.play("start_scene")
	GlobalVar.book_visible = true
	GlobalVar.addition = true
	GlobalVar.subtraction = true
	GlobalVar.division = true
	GlobalVar.multiplication = true
	player.parent = self
	GlobalVar.room = "final room"
	player.can_dash = GlobalVar.addition
	generate_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !player.dashing and player.in_pit and !on_floor:
		player.respawn()
	if $AnimationPlayer.current_animation == "dialogue":
		player.camera.position = ($StaticBody2D.global_position - player.global_position).normalized() * 70


func _on_checkpoint_body_entered(body):
	if body.name == "Player":
		player.checkpoint = player.global_position
		on_floor = true


func _on_fall_pit_body_entered(body):
	if body.name == "Player":
		player.in_pit = true

func _on_fall_pit_body_exit(body):
	if body.name == "Player":
		player.in_pit = false
		
func check_values():
	if player.calc_value == boss_value:
		player.prep_cutscene()
		$Timer.stop()
		match boss_stage:
			1:
				$AnimationPlayer.play("change_one")
			2:
				$AnimationPlayer.play("change_two")
			3:
				$AnimationPlayer.play("change_three")
			4:
				$AnimationPlayer.play("final_dialogue")
				$StaticBody2D/Label.hide()
		generate_number()
	else:
		player.wrong()
		await(get_tree().create_timer(0.5).timeout)
		get_tree().reload_current_scene()
		
func generate_number():
	boss_value = rng.randi_range(-9999,9999)
	match rng.randi_range(1,4):
		1:
			player.spell_book.symbol = SYMBOL.PLUS
			timer = 30
		2:
			player.spell_book.symbol = SYMBOL.MINUS
			timer = 30
		3:
			player.spell_book.symbol = SYMBOL.DIVIDE
			timer = 60
			boss_value = abs(boss_value)
		4:
			player.spell_book.symbol = SYMBOL.MULTIPLY
			timer = 60
			boss_value = abs(boss_value)
	temp_save = player.spell_book.symbol
	player.needed_number = boss_value
	player.prep_starting_values() 
	$StaticBody2D/Label.text = str(player.needed_number)
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_scene":
		player.fin_cutscene()
		player.collision.disabled = false
	elif anim_name == "dialogue":
		player._on_book_icon_button_down()
		boss_stage = 1
		$Timer.start(timer)
	elif anim_name == "change_one":
		player.prep_cutscene()
		$NextTask.show()
		print("Moving to second location")
		boss_stage = 2
	elif anim_name == "change_two":
		boss_stage = 3
		print("Moving to third location")
	elif anim_name == "change_three":
		boss_stage = 4
		print("FINISHED")
	elif anim_name == "final_dialogue":
		$AnimationPlayer.play("change_scene")
	elif anim_name == "change_scene":
		get_tree().change_scene_to_file("res://Scenes/end_card.tscn")

func _on_interact_body_entered(body):
	if body.name == "Player":
		if boss_stage == 0:
			player.prep_cutscene()
			$AnimationPlayer.play("dialogue")
		else:
			$Timer.start(timer)
			player._on_book_icon_button_down()


func _on_timer_timeout():
	player.wrong()
	await(get_tree().create_timer(0.5).timeout)
	get_tree().reload_current_scene()


func _on_button_pressed():
	$NextTask.hide()
	player.fin_cutscene()


func _on_checkpoint_body_exited(body):
	if body.name == "Player":
		on_floor = false
