extends State

@onready var anim: AnimatedSprite2D = $"../../anim"

func Enter():
	anim.play('run')

func Exit():
	pass

func Update(_delta:float):
	if player.velocity.x == 0:
		state_transition.emit('idle')
	elif Input.action_press("ui_accept"):
		state_transition.emit('jump')
