extends RigidBody2D

var is_spawning

func _on_coin_tree_exited():
	queue_free()
