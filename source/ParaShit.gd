extends CharacterBody2D

var swing_momentum : float = 0
@export var swing_acceleration : float = 0.1
@export var swing_max_speed : float = 4
@export var swing_direction : bool = false

@export var max_speed : float = 3

var remove_self = false

@export var delay : float = 0

@onready var start_position = position.x

func _ready():
	swing_momentum = -swing_max_speed
	if swing_direction:
		swing_acceleration *= -1
		swing_momentum *= -1
	$ParaShit0.flip_h = int(position.x) % 2 == 0

func _physics_process(delta):
	if delay > 0:
		delay -= delta
	else:
		swing_momentum += swing_acceleration
		if abs(swing_momentum) > swing_max_speed:
			swing_acceleration *= -1
			swing_momentum = swing_max_speed * sign(swing_momentum)
		position.y += max_speed
		position.x += swing_momentum
		#$Line2D.position.x -= swing_momentum
		
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
		
		$ParaShit0.rotation_degrees = (start_position - position.x) / 3
