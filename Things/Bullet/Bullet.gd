extends Area2D
class_name Bullet

const SPEED: int = 400

var direction: float = 0
var shot_by: KinematicBody2D

onready var _visual: Node2D = $Visual
onready var _collision: CollisionShape2D = $Collision


func _ready() -> void:
	_visual.rotate(direction)
	_collision.rotate(direction)


func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(direction) * SPEED * delta


func _on_Bullet_body_entered(body: Node) -> void:
	if body == shot_by:
		return

	# Tell the body it is hit
	var enemy: Enemy = body as Enemy
	if enemy:
		enemy.hit(self)

	queue_free()
