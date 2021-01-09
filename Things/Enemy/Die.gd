extends State


onready var _blood_particles: CPUParticles2D = $Visual/Blood


func enter(host) -> void:
	_blood_particles.rotate(projectile.direction)
	_blood_particles.emitting = true

	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)

	var die_jump: Vector2 = position + Vector2(30, 0).rotated(projectile.direction)
	_tween.interpolate_property(self, 'position:x', position.x, die_jump.x, .1)
	_tween.interpolate_property(self, 'position:y', position.y, die_jump.y, .1)
	_tween.start()

	var player = projectile.shot_by
	player.hit_an_enemy(self)
	if 'hit_an_enemy' in player:
		pass
