extends Node2D

var speed = 2  # rotation speed (in radians)

#Player control variables
@export var paddle_right_action = "paddle_right1"
@export var paddle_left_action := "paddle_left1"
@export var paddle_down_action := "paddle_down1"
@export var paddle_up_action := "paddle_up1"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var right_down = clamp(Input.get_action_strength(paddle_right_action)+Input.get_action_strength(paddle_down_action), 0, 1)
	var up_left = clamp(Input.get_action_strength(paddle_left_action)+Input.get_action_strength(paddle_up_action), 0, 1)
	rotation = clamp(rotation + speed * delta * (right_down-up_left), -.7, .7)
