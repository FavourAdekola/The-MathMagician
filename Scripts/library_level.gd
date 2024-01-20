extends Node2D

@onready var player = $Player
@onready var broken_floor = $"Destructible Floor"
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if anim.current_animation == "Fall Off Destructibles":
		broken_floor.visible = false
		player.position.y += 2
		player.prep_cutscene()
	else: 
		player.fin_cutscene()
		
	


func _on_trigger_destructibles_body_entered(body):
	if body.name == "Player":
		anim.play("Fall Off Destructibles")
