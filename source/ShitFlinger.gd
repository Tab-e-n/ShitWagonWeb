extends Node2D

@export var max_left : int = 0
@export var max_right : int = 0

var rand : RandomNumberGenerator = RandomNumberGenerator.new()

var Normal : PackedScene = preload("res://NormalShit.tscn")
var Para : PackedScene = preload("res://ParaShit.tscn")
var Ninja : PackedScene = preload("res://NinjaShit.tscn")
var Big : PackedScene = preload("res://BigShit.tscn")

@export var time_till_next : float = 3
@export var difficulty : int = 0

func _ready():
	#$Timer.start(3)
	rand.randomize()
	#fling()

func _physics_process(delta):
	if difficulty < 8:
		difficulty = Score.points / 10
	if Score.start_timer == 0:
		time_till_next -= delta
	if time_till_next < 0:
		timeout()

func fling(type : int = 0, start_position : int = 0, parameters : Array = [], delay : float = 0):
	var new : Node2D
	match type:
		0:
			new = Normal.instantiate()
		1:
			new = Para.instantiate()
			new.swing_direction = parameters[0]
		2:
			new = Ninja.instantiate()
		3:
			new = Big.instantiate()
			new.visibility = parameters[0]
	new.delay = delay
	new.position.x = start_position
	add_child(new)

func timeout():
	var start_position = rand.randi_range(max_left, max_right)
	match randi_range(0, difficulty):
		0, 2, 6:
			fling(0, start_position, [], randf_range(0, 1 - difficulty * 0.05))
			time_till_next = 4 - difficulty * 0.25
		1, 3:
			var direction = randi_range(0, 1) == 1
			var amount = randi_range(1, (difficulty) / 3 + 1)
			for i in range(amount):
				fling(1, start_position, [direction], i * 0.5)
			time_till_next = 4 - difficulty * 0.25 + amount * 0.5
		4, 5:
			fling(2, start_position, [8 - difficulty / 2], 4 - difficulty * 0.25)
			time_till_next = 4 - difficulty * 0.25
		7, 8:
			var delay : float = randf_range(0, 2 - difficulty * 0.1)
			fling(3, start_position, [true], delay)
			fling(3, start_position, [false], delay)
			time_till_next = 4 - difficulty * 0.25
