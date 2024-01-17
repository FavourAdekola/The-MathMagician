extends Node2D

@onready var player = $Player
@onready var broken_floor = $"Destructible Floor"
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_trigger_destructibles_body_entered(body):
	if body.name == "Player":
		anim.play("Fall Off Destructibles")
