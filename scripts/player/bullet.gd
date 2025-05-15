extends Area2D
@onready var bullet_position: Marker2D = $bullet_position
@onready var shoot_cooldown: Timer = $shoot_cooldown

var bullet_speed := 2000.0
var direction := 1
const BULLET_SCENE = preload("res://prefabs/bullet.tscn")


func _process(delta):
	position.x += bullet_speed * direction * delta
	
	
# changes bullet direction. It gets the direction from the player's script.
func set_direction(dir):
	direction = dir
	
	# if the bullet is going left
	if dir < 0:
		# changes the bullet sprite 
		$anim.scale.x = -abs($anim.scale.x)
	else:
		$anim.scale.x = abs($anim.scale.x)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
 
func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	
	if sign(bullet_position.position.x) == 1:
		bullet_instance.set_direction(1)
	else:
		bullet_instance.set_direction(-1)
	
	# the same as get_parent().add_child(bullet_instance)
	add_sibling(bullet_instance)
	
	bullet_instance.global_position = bullet_position.global_position
	shoot_cooldown.start()
