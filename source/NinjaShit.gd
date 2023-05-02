extends CharacterBody2D

var momentum : float = 2
@export var acceleration : float = 0.1
@export var max_speed : float = 12

var hit = false

@export var delay : float = 0
@export var frames : int = 8
@onready var start_frame : int = frames

func _physics_process(delta):
	$warning.visible = delay > 0
	$NinjaShit0.visible = !delay > 0 and !(hit and frames <= 0)
	$NinjaShit0.position.y = 768 / start_frame * (start_frame - frames + 1)
	$NinjaShit0/NinjaShitTrail.flip_h = !$NinjaShit0/NinjaShitTrail.flip_h
	$Collision.disabled = delay > 0 or hit or frames <= 0
	if delay > 0:
		delay -= delta
	else:
		set_velocity(Vector2(0, 0))
		if move_and_slide():
			hit = true
		
		if frames > -2:
			frames -= 1
		if frames == 0 and !hit:
			Score.miss()
		
		if frames == -2:
			queue_free()
