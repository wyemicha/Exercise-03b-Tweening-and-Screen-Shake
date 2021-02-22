extends WorldEnvironment

onready var HUD = get_node("/root/Game/HUD")

func _ready():
	show()

func show():
	if HUD.effects_blur:
		pass
	else:
		pass

func hide():
	pass

