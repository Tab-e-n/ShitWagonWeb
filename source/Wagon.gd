extends CharacterBody2D

@onready var parent : Node2D = get_parent()
@export var wagon_texture : Texture

@export var offset : int = 0
@export var speed_base : int = 5

var amount : int = 0
var off_target_pos : int = 0
var getting_off : bool = false
var speed_multiplier : float = 1
var teleport_pos : int = 0

var active : bool = true

func _ready():
	$sprite.texture = wagon_texture

func _physics_process(_delta):
	var target_pos : int = parent.target_pos + offset
	var speed : int = speed_base * speed_multiplier
	if getting_off:
		target_pos = off_target_pos
	
	if target_pos - position.x > 0:
		position.x += speed
	if target_pos - position.x < 0:
		position.x -= speed
	if abs(target_pos - position.x) <= speed:
		position.x = target_pos
		if !active:
			active = true
			parent.active_wagons += 1
	#position.x = target_pos + offset
	
	#print(abs(off_target_pos - position.x))
	if abs(off_target_pos - position.x) <= speed and getting_off:
		getting_off = false
		position.x = teleport_pos
		speed_multiplier = 1
		#print(position.x, " ", teleport_pos)
		amount = 0
		Score.score()
		if parent.active_wagons != 4:
			Score.score()
	
	set_velocity(Vector2(0, 0))
	if move_and_slide():
		catch()
		for i in get_slide_collision_count():
			get_slide_collision(i).get_collider().call("set", "remove_self", true)
	position.y = 0
	
	#$shit.scale.y = amount
	for i in range(3):
		get_node("WagonShit" + String.num_int64(i + 1)).visible = amount == i + 1
	$collision.disabled = amount >= 3

func catch():
	amount += 1
	emit_particles(0)
	
func emit_particles(type : int):
	$Particles.restart()
	$Particles.emitting = true

func go_off(target_position : int, teleport_position : int):
	getting_off = true
	off_target_pos = target_position
	teleport_pos = teleport_position
	speed_multiplier = 1.5
	parent.active_wagons -= 1
	active = false
