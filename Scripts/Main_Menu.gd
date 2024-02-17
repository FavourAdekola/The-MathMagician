extends Control

@onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("start_scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	anim.play("change_scene")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "change_scene":
		get_tree().change_scene_to_file("res://Scenes/intro_scene.tscn")
