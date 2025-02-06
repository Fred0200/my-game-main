extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $anim
@onready var hitbox_collision: CollisionShape2D = $hitbox/collision
@onready var hitbox: Area2D = $hitbox


const SPEED = 160
const JUMP_VELOCITY = -280

var is_attacking = false
var points = 00000

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Attack
	if Input.is_action_just_pressed("attack") and not is_attacking:
		
		is_attacking = true
		hitbox_collision.set_deferred('disabled', false)
		
		velocity.x = 0  # Stop horizontal movement
		anim.play('attack_1')
		await anim.animation_finished
		
		is_attacking = false
		hitbox_collision.set_deferred('disabled', true)
		
		
		

	
	
	elif not is_attacking:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction > 0:
			velocity.x = direction * SPEED
			anim.flip_h = false
			hitbox.scale.x = direction 
			anim.play('walking')
		elif direction < 0:
			velocity.x = direction * SPEED
			anim.flip_h = true
			anim.play('walking')
			hitbox.scale.x = direction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play('idle')
		

	if not is_on_floor():
		anim.play('jump')
	
	move_and_slide()

	%Label.set_text("0000{my_points}".format({'my_points': points}))
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("collectable"):
		body.queue_free()
		points += 1
		
