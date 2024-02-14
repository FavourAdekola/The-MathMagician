extends Node2D

@onready var player = $Entities/Player
@onready var gate = $Areas/Building/Gate
var gate_value = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	player.parent = self
	if GlobalVar.room == "king castle":
		player.global_position = Vector2(1557, -1616)
		gate.disabled = false
	else:
		player.global_position = Vector2(1395,1480)
	GlobalVar.room = "city maze"
	generate_number()
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
		get_tree().change_scene_to_file("res://Scenes/king_castle.tscn")

func check_values():
	if player.calc_value == gate_value and !player.can_activate_book:
		player.prep_cutscene()
		player.book_closed()
		$AnimationPlayer.play("open_well")
	else:
		player.wrong()
		generate_number()
		
func generate_number():
	player.needed_number = gate_value
	player.prep_starting_values()


func _on_activate_area_body_entered(body):
	if body.name == "Player":
		player.can_activate_book = true


func _on_activate_area_body_exited(body):
	if body.name == "Player":
		player.can_activate_book = false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open_well":
		get_tree().change_scene_to_file("res://Scenes/underground.tscn")
