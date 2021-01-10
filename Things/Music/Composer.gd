extends Node2D


onready var _music: AudioStreamPlayer = $Music
onready var _power_chords: AudioStreamPlayer = $PowerChords

const BPM: float = 85.0
const SPB: float = 60.0 / BPM

const MARGIN: float = .2
const MIN_TIME: float = .5 - MARGIN
const MAX_TIME: float = .5 + MARGIN

var _current_position: float = 0
var _position_within_beat: float = 0


func play() -> void:
	_music.seek(0)
	_music.play()
	_power_chords.seek(0)
	_power_chords.play()
	_power_chords.volume_db = -80


func stop() -> void:
	_music.stop()
	_power_chords.stop()


func _physics_process(delta: float) -> void:
	_current_position = _music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	var bar = _current_position / SPB
	_position_within_beat = bar - floor(bar)

	if _position_within_beat < MIN_TIME:
		_power_chords.volume_db = -80


func can_shoot() -> bool:
	if _position_within_beat < MIN_TIME or _position_within_beat > MAX_TIME:
		return false

	return true


func play_chords() -> void:
	_power_chords.volume_db = 1
