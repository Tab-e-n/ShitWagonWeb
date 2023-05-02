extends Node2D

@export var max_left : int = 0
@export var max_right : int = 0

var target_pos : int = 0

@onready var wagons : Array = [$Wagon1, $Wagon2, $Wagon3, $Wagon4]
@export var active_wagons = 4

var shocking : bool = false
var last_shocking : bool = false

func _ready():
	if max_left > max_right:
		max_left = max_right

func _physics_process(_delta):
	#print(active_wagons)
	last_shocking = shocking
	shocking = active_wagons == 0
	if shocking != last_shocking:
		shockwave(shocking)
	if Input.is_action_pressed("left") and target_pos > max_left:
		target_pos -= 5
	if Input.is_action_pressed("right") and target_pos < max_right:
		target_pos += 5
	
	if max_right - target_pos < 32 and wagons[3].amount >= 3 and !wagons[3].getting_off:
		reorganize(false)
	if target_pos - max_left < 32 and wagons[0].amount >= 3 and !wagons[0].getting_off:
		reorganize(true)
	
	$Wagon_Indicator.position.x = target_pos

func reorganize(move_direction : bool):
	if move_direction:
		wagons[0].go_off(-640, 640)
		var swap : Node2D = wagons[0]
		for i in range(3):
			wagons[i] = wagons[i + 1]
		wagons[3] = swap
		set_offsets()
		#print(wagons)
	else:
		wagons[3].go_off(640, -640)
		var swap : Node2D = wagons[3]
		for i in range(3):
			wagons[3 - i] = wagons[3 - i - 1]
		wagons[0] = swap
		set_offsets()
		#print(wagons)

func set_offsets():
	for i in range(4):
		wagons[i].offset = -96 + 64 * i

func shockwave(direction : bool):
	if direction:
		$shockwave/anim.play("scaleup")
	else:
		$shockwave/anim.play("scaledown")
