tool
extends KinematicBody2D
class_name Enemy

const SCALE_MIN: float = .7
const SCALE_MAX: float = 3.5

const ACCELERATION: int = 2000

onready var _tween: Tween = $Tween
onready var _visual: Node2D = $Visual
onready var _collision: CollisionShape2D = $CollisionShape2D
onready var _blood_particles: CPUParticles2D = $Visual/Blood
onready var _sprite: Sprite = $Visual/Sprite

var _max_speed: int = 100
var _motion: Vector2 = Vector2.ZERO
var _is_chasing: bool = false
var _player: Node2D

func _ready() -> void:
	_visual.scale = Vector2.ONE * rand_range(SCALE_MIN, SCALE_MAX)
	_collision.scale = _visual.scale
	_max_speed *= _visual.scale.x


func _physics_process(delta: float) -> void:
	if not _is_chasing:
		apply_friction(ACCELERATION * delta)
		return

	var angle: float = get_angle_to(_player.position)
	apply_movement(Vector2.RIGHT.rotated(angle) * ACCELERATION * delta)
	_motion = move_and_slide(_motion)


func apply_friction(amount: float) -> void:
	if _motion.length() > amount:
		_motion -= _motion.normalized() * amount
	else:
		_motion = Vector2.ZERO


func apply_movement(acceleration: Vector2) -> void:
	_motion += acceleration
	_motion = _motion.clamped(_max_speed)


func hit(projectile: Node2D) -> void:
	_blood_particles.rotate(projectile.direction)
	_blood_particles.emitting = true

	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)

	var die_jump: Vector2 = position + Vector2(30, 0).rotated(projectile.direction)
	_tween.interpolate_property(self, 'position:x', position.x, die_jump.x, .1)
	_tween.interpolate_property(self, 'position:y', position.y, die_jump.y, .1)
	_tween.start()

	_sprite.self_modulate = _sprite.self_modulate.darkened(.4)

	var player = projectile.shot_by
	player.hit_an_enemy(self)

	set_physics_process(false)


func _on_DetectionArea_body_entered(body: Node) -> void:
	if body as Player:
		_is_chasing = true
		_player = body


func _on_DetectionArea_body_exited(body: Node) -> void:
	if body as Player:
		_is_chasing = false
