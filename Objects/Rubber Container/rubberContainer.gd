extends Area
onready var limit0 = $limit0
onready var limit1 = $limit1
onready var limit2 = $limit2
onready var limit3 = $limit3
onready var limit4 = $limit4
onready var limit5 = $limit5
var rubbersStored = 0
var p1RubberCounter = 0
var p2RubberCounter = 0
var p3RubberCounter = 0
var p4RubberCounter = 0
var canPickUp = false
var pickable = false
onready var rubberContainer = $"."
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
#checks if for amount of rubber stored if amount = 10 allows pickup of containers
func _physics_process(delta):
	if rubbersStored <= 0:
		conEmpty.show()
		conHalf.hide()
		conFull.hide()
	if rubbersStored > 0 and rubbersStored < 3:
		conEmpty.hide()
		conHalf.show()
		conFull.hide()
	if rubbersStored > 3:
		conEmpty.hide()
		conHalf.hide()
		conFull.show()
	if rubbersStored >= 5:
		pickable = true
	else:
		pickable = false
	if pickable == true:
		emit_signal("canPickUp")
	if rubbersStored <= 0:
		limit0.show()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if rubbersStored == 1:
		limit0.hide()
		limit1.show()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if rubbersStored == 2:
		limit0.hide()
		limit1.hide()
		limit2.show()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if rubbersStored == 3:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.show()
		limit4.hide()
		limit5.hide()
	if rubbersStored == 4:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.show()
		limit5.hide()
	if rubbersStored >= 5:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.show()
#When p1 enters emits signal to p1 script that p1 has entered
func _on_rubberContainer_body_entered(body):
	if body.get_name() == 'Player1':
		emit_signal("p1IsEntered")
	elif body.get_name() == 'Player2':
		emit_signal("p2IsEntered")
	elif body.get_name() == 'Player3':
		emit_signal("p3IsEntered")
	elif body.get_name() == 'Player4':
		emit_signal("p4IsEntered")
#refreshes rubber counter when player stores metal
func _on_Player1_rubberStored():
	rubbersStored += p1RubberCounter
	p1RubberCounter = 0
#makes container "disappear" when picked up
func _on_Player1_rubberContPickUp():
	var location = Vector3(0,-10,0)
	rubberContainer.translate(location)
#player 1 sends signal that rubber stored +1
func _on_Player1_plusOneRubber():
	p1RubberCounter += 1
#when player 1 puts container in recycling facility returns. Add wait function in final product
func _on_Player1_rubberContainerReturn():
	var location = Vector3(0,10,0)
	rubberContainer.translate(location)
	rubbersStored = 0
	emit_signal("playAnim")
func _on_Player1_rubberContRecycled():
	emit_signal("gotRecycled")
func _on_Player2_rubberStored():
	rubbersStored += p2RubberCounter
	p2RubberCounter = 0
func _on_Player2_rubberContPickUp():
	var location = Vector3(0,-10,0)
	rubberContainer.translate(location)
func _on_Player2_plusOneRubber():
	p2RubberCounter += 1
func _on_Player2_rubberContainerReturn():
	var location = Vector3(0,10,0)
	rubberContainer.translate(location)
	rubbersStored = 0
	emit_signal("playAnim")
func _on_Player2_rubberContRecycled():
	emit_signal("gotRecycled")
func _on_Player3_rubberStored():
	rubbersStored += p3RubberCounter
	p3RubberCounter = 0
func _on_Player3_rubberContPickUp():
	var location = Vector3(0,-10,0)
	rubberContainer.translate(location)
func _on_Player3_plusOneRubber():
	p3RubberCounter += 1
func _on_Player3_rubberContainerReturn():
	var location = Vector3(0,10,0)
	rubberContainer.translate(location)
	rubbersStored = 0
	emit_signal("playAnim")
func _on_Player3_rubberContRecycled():
	emit_signal("gotRecycled")
func _on_Player4_rubberStored():
	rubbersStored += p4RubberCounter
	p4RubberCounter = 0
func _on_Player4_rubberContPickUp():
	var location = Vector3(0,-10,0)
	rubberContainer.translate(location)
func _on_Player4_plusOneRubber():
	p4RubberCounter += 1
func _on_Player4_rubberContainerReturn():
	var location = Vector3(0,10,0)
	rubberContainer.translate(location)
	rubbersStored = 0
	emit_signal("playAnim")
func _on_Player4_rubberContRecycled():
	emit_signal("gotRecycled")
