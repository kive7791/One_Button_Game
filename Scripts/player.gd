extends CharacterBody2D

# Player movement
@export var move_speed: float = 3800.0 #Delta is wierd  
@export var gravity: float = 3500.0   #starting speed strength
@export var max_fall_speed: float = 2400.0 # end speed
@export var jumpForce: float = 4500 #up level
@export var max_jump: int = 2 # max jumps allowed
@export var reset_threshold: float = 3.0 # Time (in seconds) before resetting the player if no movement
@export var reset_position: Vector2 = Vector2(28, 630) # Position to reset to

# Player health
var health: int = 10
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
	
	last_position = position  # Initialize last_position
	stationary_timer = 0.0  # Reset timer at start

func _physics_process(delta):
	check_on_floor() # Update the 'on_floor' status every frame
	
	velocity = direction * move_speed * delta # right mvoement at time at move speed
	
	# was using is_on_floor() but it was always printing out false so changed 
	# If the player is in the air (not on the floor), gravity applied
	if !on_floor:
		velocity.y += gravity * delta 
		velocity.y = clamp(velocity.y, -max_fall_speed, max_fall_speed) # Cap the fall speed to max_fall_speed
	else:
		jump_count = 0 #rest jumps
	
	#print(on_floor)
	
	# jump logic
	if Input.is_action_just_pressed("Jump") and jump_count < max_jump:
		velocity.y = -jumpForce #set jump velocity
		jump_count += 1 #increment the jump count
	
	# move the player
	move_and_slide()
	
	# Player reset 
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
