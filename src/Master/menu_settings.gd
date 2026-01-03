extends CanvasLayer

var resolutions = [Vector2(2560,1440),Vector2(1920,1080),Vector2(1280,720)]

func _ready() -> void:
	restart()

func restart() -> void:
	self.hide()
	$main_menu.show()
	$settings.hide()
	$settings/video_settings.hide()

func resume_button() -> void:
	self.hide()
	

func settings_open_button() -> void:
	$main_menu.hide()
	$settings.show()

func quit_button() -> void:
	get_tree().quit()

func back_button() -> void:
	$main_menu.show()
	$settings.hide()
	$settings/video_settings.hide()

func video_settings_open() -> void:
	$settings/video_settings.show()


func full_screen(toggled_on: bool) -> void:
	if toggled_on:
		get_window().mode = Window.MODE_FULLSCREEN
		$settings/video_settings/resolution.disabled = true
	else:
		get_window().mode = Window.MODE_WINDOWED
		$settings/video_settings/resolution.disabled = false
		get_window().position = Vector2((DisplayServer.screen_get_size().x-get_window().size.x)/2,(DisplayServer.screen_get_size().y-get_window().size.y)/2)

func resolution(index: int) -> void:
	get_window().size = resolutions[index]
	get_window().position = Vector2((DisplayServer.screen_get_size().x-get_window().size.x)/2,(DisplayServer.screen_get_size().y-get_window().size.y)/2)
