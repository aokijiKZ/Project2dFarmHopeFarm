extends Node

# Declare the audio stream players for sound effects and music
var sfx_players = []
var music_player = AudioStreamPlayer.new()

# Max number of simultaneous sound effects
const MAX_SFX = 10

# Initialize the sound manager
func _ready():
	add_child(music_player)
	music_player.bus = "Music"
	
	# Create AudioStreamPlayer instances for sound effects
	for _i in range(MAX_SFX):
		var sfx_player = AudioStreamPlayer.new()
		add_child(sfx_player)
		sfx_player.bus = "Effect"
		sfx_players.append(sfx_player)

# Play a sound effect
func play_sfx(audio_stream: AudioStream, volume: float = 1.0) -> bool:
	for sfx_player in sfx_players:
		if not sfx_player.playing:
			sfx_player.stream = audio_stream
			sfx_player.volume_db = linear2db(volume)
			sfx_player.play()
			return true
	return false

# Play background music
func play_music(audio_stream: AudioStream, volume: float = 1.0, loop: bool = true):
	music_player.stream = audio_stream
	music_player.volume_db = linear2db(volume)
	music_player.loop = loop
	music_player.play()

# Stop background music
func stop_music():
	music_player.stop()

# Convert linear volume to decibels
func linear2db(linear: float) -> float:
	if linear == 0:
		return -80.0
	return 20 * log(linear) / log(10)
