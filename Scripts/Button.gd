extends Button
signal playButton# var b = "text"
func _ready():
	pass 
func _on_StartGame_pressed():
	$ColorRect.show()
	$ColorRect/AnimationPlayer.play("fadeIn")
	emit_signal("playButton")
func _physics_process(delta):
	if Input.is_action_just_pressed("start"):
		$ColorRect.show()
		$ColorRect/AnimationPlayer.play("fadeIn")
		emit_signal("playButton")
	if Input.is_action_just_pressed("space"):
		$ColorRect.show()
		$ColorRect/AnimationPlayer.play("fadeIn")
		emit_signal("playButton")