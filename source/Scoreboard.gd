extends Node2D

func _physics_process(_delta):
	$points.text = "[center]" + String.num_int64(Score.points) + "[/center]"
	for i in range(3):
		get_node("cross" + String.num_int64(i)).visible = Score.misses > i 
	
	$Hint.visible = Score.start_timer != 0
	#$misses.text = String.num_int64(Score.misses)
