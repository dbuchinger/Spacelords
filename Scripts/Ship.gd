extends CharacterBody2D

var speed = 2.5
var ship_velocity = Vector2.ZERO
var thrust_vector = Vector2.ZERO
var ship_aim = Vector2.ZERO
var thrust = 10
var drag = .1
var bullet_reload_time = 500
var missile_reload_time = 300
var disabled = false
@export var spawn_point = global_position
var respawn_delay = 3000
var respawn_signal = 0
# These are set to the negative value of the load time so that the player can
# shoot them at the start of the game.
var current_bullet_reload = -bullet_reload_time
var current_missile_reload = -missile_reload_time

#Scene and Object initializations
@onready var game = $"/root/Game Space"
@onready var projectile_spawn = $ProjectileSpawn
var bullet = preload("res://Bullet.tscn")
var missile = preload("res://Missile.tscn")

#Player control variables
@export var ship_right_action = "ship_right1"
@export var ship_left_action := "ship_left1"
@export var ship_down_action := "ship_down1"
@export var ship_up_action := "ship_up1"
@export var fire_bullet_action := "ship_bullet1"
@export var fire_missile_action := "ship_missile1"

func _process(delta):
	if Input.is_action_pressed(fire_bullet_action) && !disabled:
			_shoot_bullet()
	if Input.is_action_pressed(fire_missile_action) && !disabled:
			_shoot_missile()
	if disabled:
		if Time.get_ticks_msec() >= respawn_signal:
			visible = true
			disabled = false
			print("ship respawned")
	print(respawn_signal)
func _physics_process(delta):
	if !disabled:
		thrust_vector = Input.get_vector(ship_left_action,ship_right_action,ship_up_action,ship_down_action)
		thrust_vector = thrust_vector.normalized() * speed
		
		if thrust_vector != Vector2.ZERO:
			ship_velocity = ship_velocity.move_toward(thrust_vector*speed, thrust*delta)
			ship_aim = thrust_vector
		else:
			ship_velocity = ship_velocity.move_toward(Vector2.ZERO, drag*delta)
		
		look_at(global_position + thrust_vector)
		var collision_info = move_and_collide(ship_velocity)
		
		if collision_info:
			if collision_info.get_collider().is_in_group("Walls"):
				ship_velocity = Vector2.ZERO
			else:
				_ship_destroyed()

func _shoot_bullet():
	if Time.get_ticks_msec() > (current_bullet_reload + bullet_reload_time):
		var new_bullet = bullet.instantiate()
		new_bullet.position = projectile_spawn.global_position
		new_bullet.velocity = ship_aim
		game.add_child(new_bullet)
		current_bullet_reload = Time.get_ticks_msec()

func _shoot_missile():
	if Time.get_ticks_msec() > (current_missile_reload + missile_reload_time):
		var new_missile = missile.instantiate()
		new_missile.position = projectile_spawn.global_position
		new_missile.velocity = ship_aim
		new_missile.rotation = global_rotation + PI/2 #Need to rotate them 90 degrees for whatever reason
		game.add_child(new_missile)
		current_missile_reload = Time.get_ticks_msec()

func _ship_destroyed():
	disabled = true
	visible = false
	ship_velocity = Vector2.ZERO
	thrust_vector = Vector2.ZERO
	respawn_signal = Time.get_ticks_msec() + respawn_delay
