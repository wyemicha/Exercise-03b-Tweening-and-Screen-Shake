extends Node

onready var HUD = get_node("/root/Game/HUD")

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	if Input.is_action_just_pressed("menu"):	
		if HUD.visible:
			get_tree().paused = false
			HUD.hide()
		else:
			get_tree().paused = true
			HUD.show()
