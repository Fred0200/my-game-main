extends Area2D


var bullet_speed := 500
var direction := 1
var rotation_speed := 7.0

func _process(delta):
	position.x += bullet_speed * direction * delta
	rotation += deg_to_rad(rotation_speed) 
	
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
 


func _on_timer_timeout() -> void:
	queue_free()
