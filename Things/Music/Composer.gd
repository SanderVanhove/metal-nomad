extends Node2D
class_name Composer


onready var _music: AudioStreamPlayer = $Music
onready var _power_chords: AudioStreamPlayer = $PowerChords

const BPM: float = 85.0
const SPB: float = 60.0 / BPM

const MARGIN: float = .2
const MIN_TIME: float = .5 - MARGIN
const MAX_TIME: float = .5 + MARGIN

var _current_position: float = 0
var _position_within_beat: float = 0


func _ready() -> void:
	_music.play()
	_power_chords.play()
	_power_chords.volume_db = -80


func _physics_process(delta: float) -> void:
	_current_position = _music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	var bar = _current_position / SPB
	_position_within_beat = bar - floor(bar)
	print(_position_within_beat)

	if _position_within_beat < MIN_TIME:
		_power_chords.volume_db = -80


func can_shoot() -> bool:
	if _position_within_beat < MIN_TIME or _position_within_beat > MAX_TIME:
		return false

	_power_chords.volume_db = 1
	return true
