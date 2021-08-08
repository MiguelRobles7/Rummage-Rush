extends Node
onready var playerAmountLabel = $playerAmount
var playerAmount = 1
var canChange = false
var buttonRight = preload("res://Assets/Sprites/butrightidle.png")
var buttonLeft = preload("res://Assets/Sprites/butleftidle.png")
var buttonRightPressed = preload("res://Assets/Sprites/butrightpress.png")
var buttonLeftPressed = preload("res://Assets/Sprites/butleftpress.png")
var startButton = preload("res://Assets/Sprites/startidle.png")
var startButtonPressed = preload("res://Assets/Sprites/startactive.png")
var isInDifficulty = true
var inst2 = preload("res://Assets/Sprites/controls.png")
var inst3 = preload("res://Assets/Sprites/rules_1.png")
var inst4 = preload("res://Assets/Sprites/rule2.png")
var i = 0
signal waitMe
onready var rightButton = $buttonRight
onready var leftButton = $buttonLeft
onready var start = $startButton
signal rightTimerOn
signal leftTimerOn
signal startTimerOn
signal startInstructions
onready var buttonSound = $buttonSound
onready var ins = $instructions
var waitOk = false
func _ready():
	pass
func _physics_process(delta):
	if canChange == true and Input.is_action_just_pressed("start") and playerAmount == 1:
		global.difficulty = 1
		global.difficultySet = true
		get_tree().change_scene("res://MainP1.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("space") and playerAmount == 1:
		global.difficulty = 1
		global.difficultySet = true
		get_tree().change_scene("res://MainP1.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("start") and playerAmount == 2:
		global.difficulty = 2
		global.difficultySet = true
		get_tree().change_scene("res://MainP2.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("space") and playerAmount == 2:
		global.difficulty = 2
		global.difficultySet = true
		get_tree().change_scene("res://MainP2.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("start") and playerAmount == 3:
		global.difficulty = 3
		global.difficultySet = true
		get_tree().change_scene("res://MainP3.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("space") and playerAmount == 3:
		global.difficulty = 3
		global.difficultySet = true
		get_tree().change_scene("res://MainP3.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("start") and playerAmount == 4:
		global.difficulty = 4
		global.difficultySet = true
		get_tree().change_scene("res://MainP4.tscn")
		buttonSound.play()
	if canChange == true and Input.is_action_just_pressed("space") and playerAmount == 4:
		global.difficulty = 4
		global.difficultySet = true
		get_tree().change_scene("res://MainP4.tscn")
		buttonSound.play()
	if Input.is_action_just_pressed("globalRight") and isInDifficulty == true:
		rightButton.set_texture(buttonRightPressed)
		buttonSound.play()
		emit_signal("rightTimerOn")
	if Input.is_action_just_pressed("globalLeft") and isInDifficulty == true:
		leftButton.set_texture(buttonLeftPressed)
		buttonSound.play()
		emit_signal("leftTimerOn")
	if playerAmount > 4:
		playerAmount = 1
		playerAmountLabel.set_text(str(playerAmount))
	if playerAmount < 1:
		playerAmount = 4
		playerAmountLabel.set_text(str(playerAmount))
	if Input.is_action_just_pressed("ui_right") and isInDifficulty == false and i == 0 and waitOk == false:
		ins.set_texture(inst2)
		i += 1
		emit_signal("waitMe")
		waitOk = true
	if Input.is_action_just_pressed("ui_right") and isInDifficulty == false and i == 1 and waitOk == false:
		ins.set_texture(inst3)
		i += 1 
		emit_signal("waitMe")
		waitOk = true
	if Input.is_action_just_pressed("ui_right") and isInDifficulty == false and i == 2 and waitOk == false:
		ins.set_texture(inst4)
		emit_signal("waitMe")
		waitOk = true
	if Input.is_action_just_pressed("start"):
		start.set_texture(startButtonPressed)
		emit_signal("startTimerOn")
		buttonSound.play()
		isInDifficulty = false
	if Input.is_action_just_pressed("space"):
		start.set_texture(startButtonPressed)
		emit_signal("startTimerOn")
		isInDifficulty = false
		buttonSound.play()
func _on_buttonRightTimer_timeout():
	playerAmount += 1
	playerAmountLabel.set_text(str(playerAmount))
	rightButton.set_texture(buttonRight)


func _on_buttonLeftTimer_timeout():
	playerAmount -= 1
	playerAmountLabel.set_text(str(playerAmount))
	leftButton.set_texture(buttonLeft)

func _on_buttonStart_timeout():
	emit_signal("startInstructions")

func _on_AnimationPlayer_animation_finished(anim_name):
	canChange = true

func _on_waitMe_timeout():
	waitOk = false
