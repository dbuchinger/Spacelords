extends Area2D

var death_time = 5000
var speed = 50
var velocity = Vector2.ZERO
var active_delay = 100
var arm_time = 1000
@onready var sprite = $Sprite2D
var armed_sprite = preload("res://Images/missile.png")

func _ready():
	death_time += Time.get_ticks_msec()
	active_delay += Time.get_ticks_msec()
	arm_time += Time.get_ticks_msec()

func _process(delta):
	if Time.get_ticks_msec() >= death_time:
		queue_free()
	if Time.get_ticks_msec() >= arm_time:
		sprite.texture = armed_sprite
		speed = 100
		
func _physics_process(delta):
	position += velocity * speed * delta

func _on_body_entered(body):
	if Time.get_ticks_msec() >= active_delay:
		queue_free()
	if body.is_in_group("Shields") && Time.get_ticks_msec() >= arm_time:
		body.queue_free()
