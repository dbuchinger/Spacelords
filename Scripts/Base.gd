extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("Destroyer"):
		queue_free()
	else:
		body.queue_free()

func _on_area_entered(area):
	if area.is_in_group("Destroyer"):
		area.queue_free()
		queue_free()
	else:
		area.queue_free()
