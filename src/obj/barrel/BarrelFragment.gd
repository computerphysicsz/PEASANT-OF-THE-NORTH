extends Node2D

const GRAVITY = 50
var velocity = Vector2()

func _ready():
	#velocity.x = RandomNumberGenerator.new().randi_range(-200,200)
	velocity.y = -500

#func _physics_process(delta):
#	velocity.y += GRAVITY * delta
#	position = position + velocity
#
#func _on_Timer_timeout():
#	queue_free()
