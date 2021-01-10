extends Control
class_name Indicator

onready var _pick: Sprite = $Visual/Pick
onready var _start: Node2D = $Start
onready var _end: Node2D = $End

var _total_dist: float
var _wrong: float = 0


func _ready() -> void:
	_total_dist = (_start.position - _end.position).x


func _process(delta: float) -> void:
	var bar_position = Composer._position_within_beat

	_pick.position.x = _start.position.x - _total_dist * bar_position

	if _wrong > _pick.position.x:
		_pick.visible = true


func missed() -> void:
	_pick.visible = false
	_wrong = _pick.position.x
