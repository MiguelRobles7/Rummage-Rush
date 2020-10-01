extends Area
onready var limit0 = $limit0
onready var limit1 = $limit1
onready var limit2 = $limit2
onready var limit3 = $limit3
onready var limit4 = $limit4
onready var limit5 = $limit5
var metalsStored = 0
var p1MetalCounter = 0
var p2MetalCounter = 0
var p3MetalCounter = 0
var p4MetalCounter = 0
var canPickUp = false
var pickable = false
onready var metalContainer = $"."
signal canPickUp
signal p1IsEntered
signal p2IsEntered
signal p3IsEntered
signal p4IsEntered
signal cannotPickUp
signal gotRecycled
signal playAnim
onready var conEmpty = $StaticBody/conEmpty
onready var conHalf = $StaticBody/conHalf
onready var conFull = $StaticBody/conFull
func _ready():
	pass
#checks if for amount of metals stored if amount = 10 allows pickup of containers
func _physics_process(delta):
	if metalsStored <= 0:
		conEmpty.show()
		conHalf.hide()
		conFull.hide()
	if metalsStored > 0 and metalsStored < 3:
		conEmpty.hide()
		conHalf.show()
		conFull.hide()
	if metalsStored > 3:
		conEmpty.hide()
		conHalf.hide()
		conFull.show()
	if metalsStored >= 5:
		pickable = true
	else:
		pickable = false
	if pickable == true:
		emit_signal("canPickUp")
	if metalsStored <= 0:
		limit0.show()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if metalsStored == 1:
		limit0.hide()
		limit1.show()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if metalsStored == 2:
		limit0.hide()
		limit1.hide()
		limit2.show()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if metalsStored == 3:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.show()
		limit4.hide()
		limit5.hide()
	if metalsStored == 4:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.show()
		limit5.hide()
	if metalsStored >= 5:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.show()
#When p1 enters emits signal to p1 script that p1 has entered
func _on_metalContainer_body_entered(body):
	if body.get_name() == 'Player1':
		emit_signal("p1IsEntered")
	elif body.get_name() == 'Player2':
		emit_signal("p2IsEntered")
	elif body.get_name() == 'Player3':
		emit_signal("p3IsEntered")
	elif body.get_name() == 'Player4':
		emit_signal("p4IsEntered")
#refreshes metal counter when player stores metal
func _on_Player1_metalStored():
	metalsStored += p1MetalCounter
	p1MetalCounter = 0
#makes container "disappear" when picked up
func _on_Player1_metalContPickUp():
	var location = Vector3(0,-10,0)
	metalContainer.translate(location)
#player 1 sends signal that metal stored +1
func _on_Player1_plusOneMetal():
	p1MetalCounter += 1
#when player 1 puts container in recycling facility returns. Add wait function in final product
func _on_Player1_metalContainerReturn():
	metalsStored = 0
	var location = Vector3(0,10,0)
	emit_signal("playAnim")
	metalContainer.translate(location)
func _on_Player1_metalContRecycled():
	emit_signal("gotRecycled")
func _on_Player2_metalStored():
	metalsStored += p2MetalCounter
	p2MetalCounter = 0
func _on_Player2_metalContPickUp():
	var location = Vector3(0,-10,0)
	metalContainer.translate(location)
func _on_Player2_plusOneMetal():
	p2MetalCounter += 1
func _on_Player2_metalContainerReturn():
	metalsStored = 0
	var location = Vector3(0,10,0)
	emit_signal("playAnim")
	metalContainer.translate(location)
func _on_Player2_metalContRecycled():
	emit_signal("gotRecycled")
func _on_Player3_metalStored():
	metalsStored += p3MetalCounter
	p3MetalCounter = 0
func _on_Player3_metalContPickUp():
	var location = Vector3(0,-10,0)
	metalContainer.translate(location)
func _on_Player3_plusOneMetal():
	p3MetalCounter += 1
func _on_Player3_metalContainerReturn():
	metalsStored = 0
	var location = Vector3(0,10,0)
	emit_signal("playAnim")
	metalContainer.translate(location)
func _on_Player3_metalContRecycled():
	emit_signal("gotRecycled")
func _on_Player4_metalStored():
	metalsStored += p4MetalCounter
	p4MetalCounter = 0
func _on_Player4_metalContPickUp():
	var location = Vector3(0,-10,0)
	metalContainer.translate(location)
func _on_Player4_plusOneMetal():
	p4MetalCounter += 1
func _on_Player4_metalContainerReturn():
	metalsStored = 0
	var location = Vector3(0,10,0)
	emit_signal("playAnim")
	metalContainer.translate(location)
func _on_Player4_metalContRecycled():
	emit_signal("gotRecycled")