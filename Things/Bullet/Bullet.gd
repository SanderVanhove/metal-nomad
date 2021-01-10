extends Area2D
class_name Bullet

var impacts: Array = [
	preload("res://Things/Bullet/impact.WAV"),
	preload("res://Things/Bullet/impact2.WAV"),
]

const SPEED: int = 450

var direction: float = 0
var shot_by: KinematicBody2D

onready var _visual: Node2D = $Visual
onready var _collision: CollisionShape2D = $Collision
onready var _impact_player: AudioStreamPlayer2D = $Impact


func _ready() -> void:
	_visual.rotate(direction)
	_collision.rotate(direction)


func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(direction) * SPEED * delta


func _on_Bullet_body_entered(body: Node) -> void:
	if body == shot_by:
		return

	_impact_player.stream.audio_stream = impacts[round(rand_range(0, len(impacts) - 1))]
	_impact_player.play()

	if body as TileMap:
		queue_free()
		return

	# Tell the body it is hit
	body.hit(self)

	_visual.visible = false
	set_process(false)

	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)

	_impact_player.connect("finished", self, "queue_free")
