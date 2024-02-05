extends StaticBody2D

@export var value = 0
@onready var anim = $AnimationPlayer

var player

func _ready():
	set_self_modulate(Color(255,255,255,255))
	anim.play("idle")

func _physics_process(delta):
	if not player == null:
		if player.calc_value == value:
			kill_process()
		if player.spell_book.visible:
			$Label.visible = true

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		body.can_activate_book = true
		player = body
		
func kill_process():
	anim.play("death")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
		player.book_closed()
