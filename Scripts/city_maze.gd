extends Node2D

@onready var player = $Entities/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVar.room == "king castle":
		player.global_position = Vector2(1557, -1616)
	GlobalVar.room = "city maze"
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
