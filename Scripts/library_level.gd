extends Node2D

@onready var player = $Player
@onready var broken_floor = $"Destructible Floor"
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVar.room = "library level"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if anim.current_animation == "Fall Off Destructibles":
		player.velocity = Vector2.ZERO
		player.prep_cutscene()
		broken_floor.visible = false
		player.position.y += 2
	else: 
		player.fin_cutscene()
		
	


func _on_trigger_destructibles_body_entered(body):
	if body.name == "Player":
		anim.play("Fall Off Destructibles")


func _on_book_body_entered(body):
	if body.name == "Player":
		GlobalVar.book_visible = true
		GlobalVar.addition = true
		player.can_dash = true
		$Book.queue_free()


func _on_checkpoint_body_entered(body):
	if body.name == "Player":
		player.checkpoint = $Checkpoints/Area2D.global_position


func _on_fall_pit_body_entered(body):
	if body.name == "Player":
		if !player.dashing:
			player.respawn()


func _on_previous_room_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://Scenes/starting_level.tscn")
