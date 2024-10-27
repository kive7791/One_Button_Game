extends CharacterBody2D

class_name player

signal game_started

# Player movement
@export var move_speed: float = 3800.0 #Delta is wierd  
@export var gravity: float = 3000.0   # speed of fall
@export var max_fall_speed: float = 3500.0 # end speed of fall
@export var jumpForce: float = 4500.0 # hieght of jump
@export var max_jump: int = 2 # max jumps allowed
@export var reset_threshold: float = 3.0 # Time (in seconds) before resetting the player if no movement
@export var reset_position: Vector2 = Vector2(28, 630) # Position to reset to

# Game 
var started = false 
# Player health
var health: int = 10
var process_input = true
# For player movement
var direction: Vector2 = Vector2(1, 0)  # Initial movement direction (right)
var jump_count: int = 0  # number of jumps
# Player position 
var on_floor: bool = true # is player on the floor
var last_position: Vector2
var stationary_timer: float = 0.0

@onready var bounds: Area2D = %playerArea
@onready var crystal_collected: Area2D = %crystal_collectable
@onready var floor_ray: RayCast2D = %RayCast2D

func _ready():
	add_to_group("Player")
	bounds.connect("bounds_hit", Callable(self, "_on_bounds_hit"))
	crystal_collected.connect("crystal_collected", Callable(self, "_on_crystal_collected"))
	
	$AnimatedSprite2D.play("Idle")
	last_position = position  # Initialize last_position
	stationary_timer = 0.0  # Reset timer at start

func _physics_process(delta):
	check_on_floor() # Update the 'on_floor' status every frame
	
	# jump and game start logic 
	if Input.is_action_just_pressed("Jump") and jump_count < max_jump and process_input:
		# Check that the game has started
		if !started:
			$AnimatedSprite2D.play("Walk")
			game_started.emit()
			started = true
		jump()
	
	# Game not start do it over
	if !started:
		return
	
	velocity = direction * move_speed * delta
	
	# was using is_on_floor() but it was always printing out false so changed 
	# If the player is in the air (not on the floor), gravity applied
	if !on_floor:
		velocity.y += gravity * delta 
		velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed) # Cap the fall speed to max_fall_speed
	else:
		jump_count = 0 #rest jumps
	
	print("Jump count: ", jump_count, "Velocity: ", velocity, "Floor? ", on_floor, "Timer: ", stationary_timer, "last position: ", last_position)
	
	# move the player
	move_and_slide()
	
	# Player position checked and reset
	check_position(delta)

func jump():
	velocity.y = -jumpForce #set jump velocity
	jump_count += 1 #increment the jump count

func check_position(delta):
	# Check if player has moved
	if position == last_position:
		stationary_timer += delta
	else:
		stationary_timer = 0.0  # Reset timer if player has moved
		last_position = position  # Update last known position
	# Check if the player has been stationary too long
	if stationary_timer >= reset_threshold:
		reset_player_position()

func reset_player_position():
	print("Player has been stationary too long, resetting position.")
	position = reset_position
	stationary_timer = 0.0  # Reset timer
	last_position = reset_position  # Update last known position

func _on_bounds_hit(body):
	# If the bounds - playerArea is hit/ interacted with then
	direction.x *= -1  # Reverse direction

func die():
	process_input = false

func stop():
	$AnimatedSprite2D.stop()
	gravity = 0 
	velocity = Vector2.ZERO

func _on_crystal_collected(body):
	# If the crystal is collected then
	# update the visual to see how many someone has out of the max
	pass
	# play a sound effect

func check_on_floor():
	on_floor = floor_ray.is_colliding()

func take_damage(dam: int) -> void:
	#Implement this later 
	print("Damage to player! Remaining health", health)
	health -= dam
	#if health <= 0:
		#Game_Over()

func game_over():
	pass
