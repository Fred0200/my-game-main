extends State

@onready var anim: AnimatedSprite2D = $"../../anim"

func Enter():
	anim.play('jump')

func Exit():
	pass

func Update(_delta:float):
	if Input.:
		state_transition.emit('run')
	elif Input.action_press("ui_accept"):
		state_transition.emit('jump')
