extends Node

@onready var audio = $AudioStreamPlayer
@onready var temple_music = preload("res://Assets/Music/LOOPFavourGameOST2.wav")
@onready var maze_music = preload("res://Assets/Music/LOOPFavourGameOST3.wav")
@onready var boss_music = preload("res://Assets/Music/LOOPFavourGameOST4.wav")

func _process(delta):
	if GlobalVar.room == "starting level":
		if audio.stream != temple_music:
			audio.stream = temple_music
			audio.play()
	if GlobalVar.room == "city maze":
		if audio.stream != maze_music:
			audio.stream = maze_music
			audio.play()
	if GlobalVar.room == "king castle":
		if audio.stream != boss_music:
			audio.stream = boss_music
			audio.play()
	if GlobalVar.room == "final room":
		if audio.stream != boss_music:
			audio.stream = boss_music
			audio.play()
	


func _on_audio_stream_player_finished():
	audio.play()
