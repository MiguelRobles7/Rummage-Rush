extends Area
onready var limit0 = $Spatial/limit0
onready var limit1 = $Spatial/limit1
onready var limit2 = $Spatial/limit2
onready var limit3 = $Spatial/limit3
onready var limit4 = $Spatial/limit4
onready var limit5 = $Spatial/limit5
func _ready():
	pass
func Segregate():
	pass
func _physics_process(delta):
	if global.segCounterLimit <= 0:
		limit0.show()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if  global.segCounterLimit == 1:
		limit0.hide()
		limit1.show()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if  global.segCounterLimit == 2:
		limit0.hide()
		limit1.hide()
		limit2.show()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if  global.segCounterLimit == 3:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.show()
		limit4.hide()
		limit5.hide()
	if  global.segCounterLimit == 4:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.show()
		limit5.hide()
	if  global.segCounterLimit >= 5:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.show()
