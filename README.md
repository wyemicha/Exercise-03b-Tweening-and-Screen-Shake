# Exercise-03b-Tweening-and-Screen-Shake
Exercise for MSCH-C220, 22 February 2021

A demonstration of this exercise is available here: [https://youtu.be/lsyN6wQYDsA](https://youtu.be/lsyN6wQYDsA)

This exercise is designed to explore adding tweening and screen shake to our boring brick breaker game (in the spirit of "Juice it or Lose it"). This builds on the last exercise (that added colors and particles).

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-03b-Tweening-and-Screen-Shake. *Edit the LICENSE and replace BL-MSCH-C220-S21 with your full name.* Commit your changes.

Clone the repository to a Local Path on your computer.

Open Godot. Import the project.godot file and open the "Tweening and Screen Shake" project.

You should see a very basic brick-breaker game with a HUD that will control certain effects: adding color, particles, and now: adding some dynamicism to the bricks, the camera, and the paddle.

The signals have all been connected, and the code should basicallly be in place. Your assignment is to edit the following scripts, completing the HUD.* if statements:

 * /Brick/Brick.gd (start_brick() and die())
 * /Paddle/Paddle.gd (start_paddle() and `_physics_process()`)
 * /Ball/Ball.gd (screen_shake())
 * /Camera/Camera.gd


We will talk in detail in class how to complete this exercise. 

First open the Brick scene (res://Brick/Brick.tscn). Right-click on the Brick node, and Add Child Node. Choose Tween.

In /Brick/Brick.gd, the start_brick() should be as follows:
```
func start_brick():
	if HUD.blocks_appear:
		var target_pos = position
		var appear_duration = randf()*appear_speed + 1.0
		position.y = -100
		$Tween.interpolate_property(self, "position", position, target_pos, appear_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		position = Vector2(position.x,target_y)
```

die() should also be replaced with the following:
```
func die():
	dying = true
	var target_color = $Color.color.darkened(0.75)
	target_color.a = 0
	var fall_duration = randf()*fall_speed + 1
	var rotate_amount = (randi() % 1440) - 720

	if HUD.blocks_fall:
		var target_pos = position
		target_pos.y = 1000
		$Tween.interpolate_property(self, "position", position, target_pos, fall_duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
		$Tween.start()
	if HUD.blocks_fade:
		$Tween.interpolate_property($Color, "color", $Color.color, target_color, fall_duration-0.25, Tween.TRANS_EXPO, Tween.EASE_IN)
		$Tween.start()
	if HUD.blocks_rotate:
		$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, rotate_amount, fall_duration-0.25, Tween.TRANS_QUINT, Tween.EASE_IN)
		$Tween.start()
	if not HUD.blocks_fade and not HUD.blocks_fall and not HUD.blocks_rotate:
		$Color.color = target_color
	if not HUD.blocks_rotate:
		rotation = 0

	collision_layer = 0
	collision_mask = 0
```
Also, update the statement on line 37:
```
	if dying and not $Particles2D.emitting and not $Tween.is_active():
```

Back in the Game.tscn, right-click on /Game/Paddle_Container/Paddle, and add a Tween node to the Paddle, too.

In /Paddle/Paddle.gd, in the `_physics_process(_delta):` function, replace the HUD.paddle_stretch condition with the following:
```
	if HUD.paddle_stretch:
		var w = 1 + (distort.x * p)
		var h = 1 - (1/distort.y * p)
		change_size(w,h)
		color.s = color_s * (1-p)
		update_color()
```
Also, the `start_paddle()` function should appear as follows:
```
func start_paddle():
	if HUD.paddle_appear:
		var target_pos = position
		position.y = -100
		$Tween.interpolate_property(self, "position", position, target_pos, fall_duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
		$Tween.start()
```

In /Ball/Ball.gd, update `_physics_process` (line 39) as follows:
```
	for body in bodies:
		if body.name == "Walls":
			if HUD.screen_shake_walls > 0:
				camera.add_trauma(trauma*HUD.screen_shake_walls)
		if body.name == "Paddle":
			if HUD.screen_shake_paddle > 0:
				camera.add_trauma(trauma*HUD.screen_shake_paddle)
		if body.is_in_group("Brick"):
			if HUD.screen_shake_blocks > 0:
				camera.add_trauma(trauma*HUD.screen_shake_blocks)
```

For the screen shake, replace the contents of Camera.gd with the following (also, add this to your Gists):
```
extends Camera2D
# Originally developed by Squirrel Eiserloh (https://youtu.be/tu-Qe66AvtY)
# Refined by KidsCanCode (https://kidscancode.org/godot_recipes/2d/screen_shake/)

export var decay = 0.8                      # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(100, 50)    # Maximum hor/ver shake in pixels.
export var max_roll = 0.1                   # Maximum rotation in radians (use sparingly).
export (NodePath) var target                # Assign the node this camera will follow.

var trauma = 0.0                            # Current shake strength.
var trauma_power = 2                        # Trauma exponent. Use [2, 3].
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
	randomize()
	noise.seed = randi()
	noise.period = 4
	noise.octaves = 2

func _process(delta):
	if target:
		global_position = get_node(target).global_position
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()
		
func shake():
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
	
func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)
```

Test the project. You should be able to turn on and off the effects using the Menu (press Esc to activate).

Quit Godot. In GitHub desktop, add a summary message, commit your changes and push them back to GitHub. If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-03b-Tweening-and-Screen-Shake) on Canvas.

The final state of the file should be as follows (replacing my information with yours):
```
# Exercise-03b-Tweening-and-Screen-Shake
Exercise for MSCH-C220, 22 February 2021

The second part of an exploration of the "Juice it or Lose it" GDC 2012 presentation in Godot.

## Implementation
Built using Godot 3.2.3

## References
[Juice it or Lose it](https://www.youtube.com/watch?v=Fy0aCDmgnxg)

## Future Development
Music and sound effects; ball trail; shaders; add a face!

## Created by 
Jason Francis
```
