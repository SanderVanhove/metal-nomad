extends Camera2D
class_name ShakingCamera

const MAX_CAMERA_OFFSET: int = 50
const CAMERA_OFFSET_MULT: Vector2 = Vector2(.2, .4)

onready var _screen_shake: ScreenShake = $ScreenShake

var _last_offset: Vector2


func _process(delta: float) -> void:
	offset = (get_local_mouse_position() * CAMERA_OFFSET_MULT).clamped(MAX_CAMERA_OFFSET)


func trigger_small_shake() -> void:
	_screen_shake.start(.1, 15, 10, 2)


func trigger_medium_shake() -> void:
	_screen_shake.start(.1, 20, 50, 5)
