extends Area2D

var death_time = 0
var speed = 300
var velocity = Vector2.ZERO

func _ready():
	death_time = Time.get_ticks_msec() + 2500

func _process(delta):
	if Time.get_ticks_msec() >= death_time:
		queue_free()

func _physics_process(delta):
	position += velocity * speed * delta
