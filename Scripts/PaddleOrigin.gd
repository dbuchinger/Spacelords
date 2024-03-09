extends Node2D

var speed = 2  # rotation speed (in radians)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var right_down = clamp(Input.get_action_strength("ui_right")+Input.get_action_strength("ui_down"), 0, 1)
	var up_left = clamp(Input.get_action_strength("ui_left")+Input.get_action_strength("ui_up"), 0, 1)
	rotation = clamp(rotation + speed * delta * (right_down-up_left), -.7, .7)
