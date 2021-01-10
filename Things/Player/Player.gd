extends KinematicBody2D
class_name Player

onready var bullet_class = preload("res://Things/Bullet/Bullet.tscn")

const MAX_SPEED: int = 300
const ACCELERATION: int = 2000

var _motion: Vector2 = Vector2.ZERO

onready var _camera: ShakingCamera = $Camera
onready var _composer: Composer = $Composer
onready var _sprite: AnimatedSprite = $Visual/Sprite
onready var _chord_timer: Timer = $Chord
onready var _can_move: bool = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		fire_bullet(event.position)


func fire_bullet(mouse_position: Vector2) -> void:
	if not _composer.can_shoot():
		return

	var bullet = bullet_class.instance()

	bullet.position = position
	bullet.direction = get_local_mouse_position().angle()
	bullet.shot_by = self

	get_parent().add_child(bullet)

	_camera.trigger_small_shake()

	_sprite.animation = "Chord"
	_sprite.connect("animation_finished", self, "chord_is_strum")
	_can_move = false


func chord_is_strum() -> void:
	_can_move = true


func hit_an_enemy(enemy: Node2D) -> void:
	_camera.trigger_medium_shake()


func _physics_process(delta: float) -> void:
	if not _can_move:
		return

	var axis: Vector2 = get_input_axis()

	if axis == Vector2.ZERO:
		apply_friction(ACCELERATION * delta)
		_sprite.animation = "Idle"
	else:
		apply_movement(axis * ACCELERATION * delta)
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


func _on_Chord_timeout() -> void:
	_can_move = true
