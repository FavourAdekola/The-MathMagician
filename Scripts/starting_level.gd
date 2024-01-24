extends Node2D
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVar.room == "library level":
		player.global_position = Vector2(14,400)
		GlobalVar.room  = "starting level"
	GlobalVar.room = "starting level"
	player.can_dash = GlobalVar.addition


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_entrance_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/library_level.tscn")


func _on_book_interaction_body_entered(body):
	if body.name == "Player":
		player.can_activate_book = true


func _on_book_interaction_body_exited(body):
	if body.name == "Player":
		player.can_activate_book = false
