extends AudioStreamPlayer

const level_music = preload("res://sfx/music/591037__kbrecordzz__dungeon-ambience-piano.mp3")

func _play_music(music: AudioStream, volume = -15):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	play()
	
func play_music_level():
	_play_music(level_music)
	
