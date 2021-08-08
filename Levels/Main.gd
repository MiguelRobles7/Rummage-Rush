extends Spatial
onready var trash = preload("res://Objects/Center Trash/Trash.tscn")
onready var trash2 = preload("res://Objects/Center Trash/Trash2.tscn")
onready var trash_container = get_node("TrashContainer")
onready var segMetal = preload("res://Objects/Recycled Objects/SegMetal.tscn")
onready var segMetalContainer = get_node("SegMetalContainer")
onready var segPlastic = preload("res://Objects/Recycled Objects/SegPlastic.tscn")
onready var segPlasticContainer = get_node("SegPlasticContainer")
onready var segRubber = preload("res://Objects/Recycled Objects/SegRubber.tscn")
onready var segRubberContainer = get_node("SegRubberContainer")
onready var WaitLabel = get_node("Difficulty/TrashSpawner/WaitLabel")
onready var scoreLabel = get_node("Game Control/scoreControl/score")
onready var player1Pos = get_node("Player1")
onready var player2Pos = get_node("Player2")
onready var player3Pos = get_node("Player3")
onready var player4Pos = get_node("Player4")
onready var hazards = preload("res://Objects/Hazards/Hazard.tscn")
onready var hazards2 = preload("res://Objects/Hazards/Hazard2.tscn")
onready var HazardsContainer = $HazardsContainer
onready var goodTrash = $trashIndicators/trashgood
onready var okTrash = $trashIndicators/trask
onready var badTrash = $trashIndicators/trashbad
onready var centerAnim = $"Center Area/PlayerAnim/AnimationPlayer"
onready var metalRecAnim = $MetalRecycle/StaticBody/Anim/Hello
onready var plasticRecAnim = $"PlasticRecycle/StaticBody/Spatial/Scene Root/Scene Root/AnimationPlayer2"
onready var rubberRecAnim = $RubberRecycle/StaticBody/Spatial/AnimationPlayer
onready var metalBelt = $metalBelt/AnimationPlayer
onready var plasticBelt = $plasticBelt/AnimationPlayer
onready var rubberBelt = $rubberBelt/AnimationPlayer
onready var segregationAnim = $segregationAnim/AnimationPlayer
var rng = RandomNumberGenerator.new()
var p1TrashPickUpLimit = 0
var p2TrashPickUpLimit = 0
var p3TrashPickUpLimit = 0
var p4TrashPickUpLimit = 0
var score = 0
var amountToSpawn = 2
var trashAmount = 0
var p1SegTrash = false
var p2SegTrash = false
var p3SegTrash = false
var p4SegTrash = false
var waitTime = 10
signal plusOneTrash
signal startSegTimer
onready var coinsSound = $coinsSound
func _ready():
	randomize()
	setTime()
	$Difficulty/AmountToSpawn.start()
func _physics_process(delta):
	if global.difficultySet == true:
		if global.difficulty == 1:
			waitTime = 20
			spawn_trash(2)
		if global.difficulty == 2:
			waitTime = 16
			spawn_trash(4)
		if global.difficulty == 3:
			waitTime = 12
			spawn_trash(5)
		if global.difficulty == 4:
			waitTime = 8
			spawn_trash(6)
		global.difficultySet = false
	if trashAmount > 30:
		global.segCounterLimit = 0
		get_tree().change_scene("res://UI/Gameover.tscn")
	global.coins = score
	if score < 0:
		score = 0
		scoreLabel.set_text(str(score))
	if trashAmount < 10:
		goodTrash.show()
		badTrash.hide()
		okTrash.hide()
	elif trashAmount >= 10 and trashAmount <= 20:
		goodTrash.hide()
		badTrash.hide()
		okTrash.show()
	elif trashAmount > 20:
		goodTrash.hide()
		badTrash.show()
		okTrash.hide()
	if global.segCounterLimit >= 9:
		global.segCounterLimit = 0
	if global.segCounterLimit <= 0:
		global.segCounterLimit = 0
func spawn_trash(num):
	for i in range(num):
		trashAmount += 1
		emit_signal("plusOneTrash")
		centerAnim.play("center")
func _on_TrashSpawner_timeout():
	setTime()
func setTime():
	WaitLabel.set_text(str(waitTime))
	$Difficulty/TrashSpawner.set_wait_time(float(waitTime))
	$Difficulty/TrashSpawner.start()
	waitTime -= (waitTime * 0.02)
	if waitTime < 3:
		waitTime = 3
func _on_AmountSpawned_timeout():
	if global.difficulty == 1:
		amountToSpawn += 1
	if global.difficulty == 2:
		amountToSpawn += 2
	if global.difficulty == 3:
		amountToSpawn += 2
	if global.difficulty == 4:
		amountToSpawn += 3
	spawn_trash(int(amountToSpawn))
func updateScore():
	if global.difficulty == 1:
		score += 500
	if global.difficulty == 2:
		score += 400
	if global.difficulty == 3:
		score += 300
	if global.difficulty == 4:
		score += 200
	scoreLabel.set_text(str(score))
	coinsSound.play()
func spawnSeg(num):
	for i in range(num):
		rng.randomize()
		var random = rng.randi_range(1, 3)
		if random == 1:
			var m = segMetal.instance()
			segMetalContainer.add_child(m)
			m.translate(Vector3(rand_range(-3.7,-3.2),.3,.8))
		elif random == 2:
			var m = segPlastic.instance()
			segPlasticContainer.add_child(m)
			m.translate(Vector3(rand_range(-3.7,-3.2),.3,.8))
		elif random == 3: 
			var m = segRubber.instance()
			segRubberContainer.add_child(m)
			m.translate(Vector3(rand_range(-3.7,-3.2),.3,.8))
func _on_Player1_hazardSpawn():
	rng.randomize()
	var random = rng.randi_range(1, 2)
	if random == 1:
		var location
		location = player1Pos.translation
		var m = hazards.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
	if random == 2:
		var location
		location = player1Pos.translation
		var m = hazards2.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
func _on_Player1_updateScore():
	updateScore()
func _on_Player1_trashPickedUp():
	trashAmount -= 1
func _on_Player1_minusScore():
	score += -50
	scoreLabel.set_text(str(score))
func _on_Player1_trashCount():
	p1TrashPickUpLimit += 1
func _on_Player1_trashSegregated():
	p1SegTrash = true
func _on_Player1_tLim1():
	p1TrashPickUpLimit -= 1
func _on_Player1_tLim2():
	p1TrashPickUpLimit -= 2
func _on_Player1_tLim3():
	p1TrashPickUpLimit -= 3
func _on_Player1_trashDumped():
	p1TrashPickUpLimit = 0
func _on_Player2_hazardSpawn():
	rng.randomize()
	var random = rng.randi_range(1, 2)
	if random == 1:
		var location
		location = player2Pos.translation
		var m = hazards.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
	if random == 2:
		var location
		location = player2Pos.translation
		var m = hazards2.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
func _on_Player2_updateScore():
	updateScore()
func _on_Player2_trashPickedUp():
	trashAmount -= 1
func _on_Player2_minusScore():
	score += -50
	scoreLabel.set_text(str(score))
func _on_Player2_trashCount():
	p2TrashPickUpLimit += 1
func _on_Player2_trashSegregated():
	p2SegTrash = true
func _on_Player2_tLim1():
	p2TrashPickUpLimit -= 1
func _on_Player2_tLim2():
	p2TrashPickUpLimit -= 2
func _on_Player2_tLim3():
	p2TrashPickUpLimit -= 3
func _on_Player2_trashDumped():
	p2TrashPickUpLimit = 0
func _on_Player3_hazardSpawn():
	rng.randomize()
	var random = rng.randi_range(1, 2)
	if random == 1:
		var location
		location = player3Pos.translation
		var m = hazards.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
	if random == 2:
		var location
		location = player3Pos.translation
		var m = hazards2.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
func _on_Player3_updateScore():
	updateScore()
func _on_Player3_trashPickedUp():
	trashAmount -= 1
func _on_Player3_minusScore():
	score += -50
	scoreLabel.set_text(str(score))
func _on_Player3_trashCount():
	p3TrashPickUpLimit += 1
func _on_Player3_trashSegregated():
	p3SegTrash = true
func _on_Player3_tLim1():
	p3TrashPickUpLimit -= 1
func _on_Player3_tLim2():
	p3TrashPickUpLimit -= 2
func _on_Player3_tLim3():
	p3TrashPickUpLimit -= 3
func _on_Player3_trashDumped():
	p3TrashPickUpLimit = 0
func _on_Player4_hazardSpawn():
	rng.randomize()
	var random = rng.randi_range(1, 2)
	if random == 1:
		var location
		location = player4Pos.translation
		var m = hazards.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
	if random == 2:
		var location
		location = player4Pos.translation
		var m = hazards2.instance()
		HazardsContainer.add_child(m)
		rng.randomize()
		var random2 = rng.randi_range(1, 4)
		if random2 == 1:
			m.translate(Vector3(location.x * 9, location.y, location.z * 9.2))
		elif random2 == 2:
			m.translate(Vector3(location.x * 9, location.y, location.z * 10.5))
		elif random2 == 3:
			m.translate(Vector3(location.x * 11, location.y, location.z * 10.5))
		elif random2 == 4:
			m.translate(Vector3(location.x * 11, location.y, location.z * 9.2))
func _on_Player4_updateScore():
	updateScore()
func _on_Player4_trashPickedUp():
	trashAmount -= 1
func _on_Player4_minusScore():
	score += -50
	scoreLabel.set_text(str(score))
func _on_Player4_trashCount():
	p4TrashPickUpLimit += 1
func _on_Player4_trashSegregated():
	p4SegTrash = true
func _on_Player4_tLim1():
	p4TrashPickUpLimit -= 1
func _on_Player4_tLim2():
	p4TrashPickUpLimit -= 2
func _on_Player4_tLim3():
	p4TrashPickUpLimit -= 3
func _on_Player4_trashDumped():
	p4TrashPickUpLimit = 0
func _on_metalContainer_playAnim():
	metalRecAnim.play("metal")
func _on_rubberContainer_playAnim():
	rubberRecAnim.play("rubber")
func _on_plasticContainer_playAnim():
	plasticRecAnim.play("plastic")
	
func _on_Player1_segMetalGo():
	metalBelt.play("belt")
func _on_Player1_segPlasticGo():
	plasticBelt.play("belt")
func _on_Player1_segRubberGo():
	rubberBelt.play("belt")

func _on_Player1_segregateAnimPlay():
	segregationAnim.play("segregate")
	emit_signal("startSegTimer")

func _on_segregationAnimTimer_timeout():
	if p1SegTrash == true:
		spawnSeg(p1TrashPickUpLimit)
		p1TrashPickUpLimit = 0
		p1SegTrash = false
	if p2SegTrash == true:
		spawnSeg(p2TrashPickUpLimit)
		p2TrashPickUpLimit = 0
		p2SegTrash = false
	if p3SegTrash == true:
		spawnSeg(p3TrashPickUpLimit)
		p3TrashPickUpLimit = 0
		p3SegTrash = false
	if p4SegTrash == true:
		spawnSeg(p4TrashPickUpLimit)
		p4TrashPickUpLimit = 0
		p4SegTrash = false
func _on_Player2_segMetalGo():
	metalBelt.play("belt")
func _on_Player2_segPlasticGo():
	plasticBelt.play("belt")
func _on_Player2_segRubberGo():
	rubberBelt.play("belt")

func _on_Player2_segregateAnimPlay():
	segregationAnim.play("segregate")
	emit_signal("startSegTimer")
func _on_Player3_segMetalGo():
	metalBelt.play("belt")
func _on_Player3_segPlasticGo():
	plasticBelt.play("belt")
func _on_Player3_segRubberGo():
	rubberBelt.play("belt")

func _on_Player3_segregateAnimPlay():
	segregationAnim.play("segregate")
	emit_signal("startSegTimer")
	
func _on_Player4_segMetalGo():
	metalBelt.play("belt")
func _on_Player4_segPlasticGo():
	plasticBelt.play("belt")
func _on_Player4_segRubberGo():
	rubberBelt.play("belt")

func _on_Player4_segregateAnimPlay():
	segregationAnim.play("segregate")
	emit_signal("startSegTimer")
