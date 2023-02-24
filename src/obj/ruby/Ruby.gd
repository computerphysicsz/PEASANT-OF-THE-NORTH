extends Area2D

# Mask only collides with the player, thus this only collides with the player. Checkmate.
func _on_Ruby_body_entered(_body):
	queue_free()
