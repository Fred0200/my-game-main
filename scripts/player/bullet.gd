extends Area2D


var bullet_speed := 1000
var direction := 1


func _process(delta):
	position.x += bullet_speed * direction * delta
	
	
# changes bullet direction. It gets the direction from the player's script.
func set_direction(dir):
	direction = dir
	
	# if the bullet is going left
	#if dir < 0:
		## changes the bullet sprite 
		#$anim.scale.x = -abs($anim.scale.x)
	#else:
		#$anim.scale.x = abs($anim.scale.x)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
 
