extends CharacterBody2D

var speed = 2.5
var ship_velocity = Vector2.ZERO
var thrust_vector = Vector2.ZERO
var ship_aim = Vector2.ZERO
var thrust = 10
var drag = .1
var reload_time = 500
var current_reload = 0

@onready var game = $"/root/Game Space"
@onready var bullet_spawn = $BulletSpawn
var bullet = preload("res://Bullet.tscn")

func _process(delta):
	if Input.is_action_pressed("ship_fire"):
			_shoot_bullet()

func _physics_process(delta):
	#thrust_vector.x = Input.get_action_strength("ship_right") - Input.get_action_strength("ship_left")
	#thrust_vector.y = Input.get_action_strength("ship_down") - Input.get_action_strength("ship_up")
	thrust_vector = Input.get_vector("ship_left","ship_right","ship_up","ship_down")
	thrust_vector = thrust_vector.normalized() * speed
	
	if thrust_vector != Vector2.ZERO:
		ship_velocity = ship_velocity.move_toward(thrust_vector*speed, thrust*delta)
		ship_aim = thrust_vector
	else:
		ship_velocity = ship_velocity.move_toward(Vector2.ZERO, drag*delta)
	look_at(global_position + thrust_vector)
	print(global_position, " | ", thrust_vector, " | ", global_position + thrust_vector)
	var collision_info = move_and_collide(ship_velocity)
	
	if collision_info:
		if collision_info.get_collider().is_in_group("Walls"):
			ship_velocity = Vector2.ZERO
		else:
			queue_free()

func _shoot_bullet():
	if Time.get_ticks_msec() > (current_reload + reload_time):
		var new_bullet = bullet.instantiate()
		new_bullet.position = bullet_spawn.global_position
		new_bullet.velocity = ship_aim
		game.add_child(new_bullet)
		current_reload = Time.get_ticks_msec()
	
