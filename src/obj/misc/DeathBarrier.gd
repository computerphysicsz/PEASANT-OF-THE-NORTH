extends Area2D

func _on_DeathBarrier_body_entered(_body):
	_body.emit_signal("killed")
	queue_free()
