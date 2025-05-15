extends State

@export var player : CharacterBody2D
@onready var anim: AnimatedSprite2D = $"../../anim"

const JUMP_VELOCITY = -400

func Enter():
	anim.play('jump')
	player.velocity.y = JUMP_VELOCITY  

func Update(_delta:float):
	if player.is_on_floor():
		Transitioned.emit(self, 'idle')

func Physics_Update(_delta):
	player.move_player()
