extends Node2D

var speed = 3  # rotation speed (in radians)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_right"):
		rotation = clamp(rotation + speed * delta, -.65, .65)
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_left"):
		rotation = clamp(rotation - speed * delta, -.65, .65)
