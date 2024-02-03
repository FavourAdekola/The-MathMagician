extends StaticBody2D

@export var value = 0
var transperency = 255

var player


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
	set_self_modulate(Color(255,255,255,transperency))
	transperency -= 5
	await get_tree().create_timer(0.1)
	if transperency == 0:
		queue_free()
