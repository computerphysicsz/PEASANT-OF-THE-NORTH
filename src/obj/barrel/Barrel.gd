extends Area2D

#const fragment = preload("res://src/obj/barrel/BarrelFragment.tscn")

# Ditto with the Ruby. Mask only collides with the player, thus this only collides with the player.
func _on_Barrel_body_entered(_body):
#	for i in 3:
#		var frag = fragment.instance()
#		frag.global_position = global_position
#		frag.set_as_toplevel(true)
#		add_child(frag)
	_body.emit_signal("barrel_jump")
	queue_free()
