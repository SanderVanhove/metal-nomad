extends KinematicBody2D
class_name Player

onready var bullet_class = preload("res://Things/Bullet/Bullet.tscn")
var misses: Array = [
	preload("res://Things/Player/miss1.wav"),
	preload("res://Things/Player/miss2.wav"),
]

const MAX_SPEED: int = 300
const ACCELERATION: int = 2000

var _motion: Vector2 = Vector2.ZERO

onready var _camera: ShakingCamera = $Camera
onready var _sprite: AnimatedSprite = $Visual/Sprite
onready var _chord_particles: CPUParticles2D = $Visual/ChordParticles
onready var _indicator: Indicator = $Camera/Control/Indicator
onready var _miss_player: AudioStreamPlayer2D = $Miss

onready var _is_shooting: bool = false
onready var _is_dead: bool = true
onready var _last_click: float = 1


func reset() -> void:
	_sprite.animation = "Idle"
	_is_dead = false


func _process(delta: float) -> void:
	if _last_click > Composer._position_within_beat:
		_last_click = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		fire_bullet(event.position)


func fire_bullet(mouse_position: Vector2) -> void:
	if _is_shooting or not Composer.can_shoot() or _last_click > 0:
		_last_click = Composer._position_within_beat
		_indicator.missed()
		_miss_player.stream.audio_stream = misses[round(rand_range(0, len(misses) - 1))]
		_miss_player.play()
		return

	Composer.play_chords()

	var bullet = bullet_class.instance()

	bullet.position = position
	bullet.direction = get_local_mouse_position().angle()
	bullet.shot_by = self

	get_parent().add_child(bullet)

	_camera.trigger_small_shake()

	_chord_particles.restart()
	_chord_particles.emitting = true

	_sprite.animation = "Chord"
	_sprite.connect("animation_finished", self, "chord_is_strum")
	_is_shooting = true


func chord_is_strum() -> void:
	_is_shooting = false


func hit_an_enemy(enemy: Node2D) -> void:
	_camera.trigger_medium_shake()


func _physics_process(delta: float) -> void:
	if _is_dead:
		return

	var axis: Vector2 = get_input_axis()

	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)

		if not _is_shooting:
			_sprite.animation = "Idle"
	else:
		apply_movement(axis * ACCELERATION * delta)
		if not _is_shooting:
			_sprite.animation = "Run"

	_sprite.flip_h = get_local_mouse_position().x < 0

	_motion = move_and_slide(_motion)


func get_input_axis() -> Vector2:
	var x = 0
	var y = 0

	if Input.is_action_pressed("ui_right"):
		x += 1
	if Input.is_action_pressed("ui_left"):
		x -= 1

	if Input.is_action_pressed("ui_down"):
		y += 1
	if Input.is_action_pressed("ui_up"):
		y -= 1

	return Vector2(x, y).normalized()


func apply_friction(amount: float) -> void:
	if _motion.length() > amount:
		_motion -= _motion.normalized() * amount
	else:
		_motion = Vector2.ZERO


func apply_movement(acceleration: Vector2) -> void:
	_motion += acceleration
	_motion = _motion.clamped(MAX_SPEED)


func _on_Area2D_body_entered(body: Node) -> void:
	if body as KinematicBody2D:
		_is_dead = true
		(get_parent() as Level).respawn()
