extends CharacterBody2D

@onready var player = get_tree().current_scene.get_node('player')
@onready var anim: AnimatedSprite2D = $anim

const SPEED = 50
const JUMP_VELOCITY = -300.0
const AIR_FRICTION = 0.5

var player_position
var target_position 
var distance
var can_follow_player = false
var direction = 1

var is_attacking = false

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_follow_player == true:
		#player_position = player.global_position
		#target_position = (player_position - global_position).normalized()
		#distance = global_position.distance_to(player.global_position) 
		
		var dir_to_player = sign(global_position.direction_to(player.global_position))
		
		if dir_to_player:
			#velocity.x = lerp(velocity.x, dir_to_player.x * SPEED, AIR_FRICTION)
			velocity.x = dir_to_player.x * SPEED
			if not is_attacking:
				anim.play("walking")
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)

		check_dir()
		move_and_slide()


func _on_follow_player_detector_body_entered(body: Node2D) -> void:
	can_follow_player = true 
	

# para mais tarde
func check_dir():
	var dir_to_player = sign(global_position.direction_to(player.global_position))
	
	if (dir_to_player.x > 0 and direction < 0) or (dir_to_player.x < 0 and direction > 0):
		anim.scale.x *= -1
		direction *= -1


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		anim.play("attack 1")
		is_attacking = true
		
func _on_anim_animation_finished() -> void:
	is_attacking = false
