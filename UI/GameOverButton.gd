extends Button

func _ready():
	pass 
func _physics_process(delta):
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene("res://UI/Results.tscn")
func _on_Button_pressed():
	get_tree().change_scene("res://UI/Results.tscn")
