extends Camera2D

#@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0
@export var shake_strength: float = 0.0
var rng = RandomNumberGenerator.new()


func apply_shake(shake_val: float):
	shake_strength = shake_val

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
	
	offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
