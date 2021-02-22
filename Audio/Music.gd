extends AudioStreamPlayer

onready var HUD = get_node("/root/Game/HUD")


func _ready():
	HUD.connect("changed",self,"_on_HUD_changed")

func play_music():
	pass

func _on_HUD_changed():
	play_music()

