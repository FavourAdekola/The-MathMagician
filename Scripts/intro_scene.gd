extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("start_scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_scene":
		get_tree().change_scene_to_file("res://Scenes/starting_level.tscn")
