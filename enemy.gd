extends CharacterBody2D

@onready var player = get_tree().current_scene.get_node('player')
@onready var anim: AnimatedSprite2D = $anim
@onready var hitbox: Area2D = $hitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $collision

const SPEED = 50
const JUMP_VELOCITY = -300.0
const AIR_FRICTION = 0.5

var health = 100
var player_position
var target_position 
var distance
var can_follow_player = false
var direction = 1

var is_attacking = false
var is_dead = false



func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_follow_player == true and not is_dead:
		#player_position = player.global_position
		#target_position = (player_position - global_position).normalized()
		#distance = global_position.distance_to(player.global_position) 
		
		var dir_to_player = sign(global_position.direction_to(player.global_position))
		
		if dir_to_player:
			#velocity.x = lerp(velocity.x, dir_to_player.x * SPEED, AIR_FRICTION)
			velocity.x = dir_to_player.x * SPEED
			if not is_attacking:
				anim.play("walking")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		check_dir()
		move_and_slide()


func _on_follow_player_detector_body_entered(body: Node2D) -> void:
	can_follow_player = true 


func check_dir():
	var dir_to_player = sign(global_position.direction_to(player.global_position))
	
	if (dir_to_player.x > 0 and direction < 0) or (dir_to_player.x < 0 and direction > 0):
		scale.x *= -1
		direction *= -1


func _on_detect_player_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		#anim.play("attack 1")
		animation_player.play('toma_pau')
		is_attacking = true
		

func _on_anim_animation_finished() -> void:
	is_attacking = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("hitbox") or area.name == "hitbox":
	
		if area.name == "hitbox":
			health = health - 50
			Global.score += 500
		else:
			health -= 25
			area.queue_free()
		
		if health > 0:
			anim.play("hurt")
		else:
			is_dead = true
			set_collision_layer_value(3, false) # so the player can move past him
			anim.play("death")
			await anim.animation_finished
			queue_free()
		
