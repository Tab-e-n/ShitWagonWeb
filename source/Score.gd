extends Node2D

var points : int = 0
var misses : int = 0

var start_timer = 1

func _input(event):
	if event is InputEventKey:
		start_timer = 0

#func _physics_process(_delta):
	#if start_timer > 0:
	#	start_timer -= 1

func score():
	points += 1
	if points % 10 == 0 and misses > 0:
		misses -= 1

func miss():
	if misses == 3:
		misses = 0
		get_tree().change_scene_to_file("res://LoseScene.tscn")
	else:
		misses += 1
