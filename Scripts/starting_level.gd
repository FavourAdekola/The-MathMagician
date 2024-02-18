extends Node2D
@onready var player = $Player
var gate_value = 2
var shown_hint = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player.parent = self
	
	if GlobalVar.room == "library level":
		player.global_position = Vector2(14,400)
	else:
		$AnimationPlayer.play("start_scene")
		player.prep_cutscene()
	GlobalVar.room = "starting level"
	player.can_dash = GlobalVar.addition
	generate_number()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$"Main Room/Label".visible = player.spell_book.visible
	if !shown_hint:
		$"Control/SpellBook Instructions".visible = player.spell_book.visible
	
func check_values():
	if player.calc_value == gate_value:
		$AnimationPlayer.play("Door Opens")
		player.prep_cutscene()
	else:
		player.wrong()
		generate_number()
		
func generate_number():
	player.needed_number = gate_value
	player.prep_starting_values()

func _on_entrance_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/library_level.tscn")


func _on_book_interaction_body_entered(body):
	if body.name == "Player":
		player.can_activate_book = true


func _on_book_interaction_body_exited(body):
	if body.name == "Player":
		player.can_activate_book = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Door Opens":
		player.book_closed()
	if anim_name == "start_scene":
		$AnimationPlayer.play("dialogue")
	if anim_name == "dialogue":
		$Control/PopupPanel.show()


func _on_exit_door_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/Exit_Hall.tscn")


func _on_button_pressed():
	$Control/PopupPanel.hide()
	$"Control/SpellBook Instructions".hide()
	player.fin_cutscene()


func _on_spell_book_instructions_visibility_changed():
	if player.spell_book.visible:
		shown_hint = true
		player.prep_cutscene()
