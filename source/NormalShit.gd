extends CharacterBody2D

var momentum : float = 2
@export var acceleration : float = 0.1
@export var max_speed : float = 12

var remove_self = false

@export var delay : float = 0

func _ready():
	
	$NormalShit0.flip_h = int(position.x) % 2 == 0

func _physics_process(delta):
	if delay > 0:
		delay -= delta
	else:
		momentum += acceleration
		if momentum > max_speed:
			momentum = max_speed
		position.y += int(momentum)
		
		set_velocity(Vector2(0, 0))
		move_and_slide()
		
		if remove_self: queue_free()
		remove_self = move_and_slide()
		#for i in get_slide_collision_count():
			#var collision = get_slide_collision(i)
			#if collision != null:
			#	collision.get_collider().catch()
			#remove_self = true
		
		if position.y > 800:
			Score.miss()
			queue_free()
