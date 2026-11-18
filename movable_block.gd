extends CharacterBody2D
var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
@export var speed: float = 300.0
@export var drag_responsiveness: float = 20.0  # Higher = snappier tracking to the mouse
@export var max_throw_speed: float = 1500.0    # Caps extreme flinging speeds
@export var release_friction: float = 0.70     # 0.90 = slides far, 0.70 = stops quickly
@export var gravity: float = 1800           # Set to ~980.0 if you want boxes to fall
@export var scroll_left: float = -100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_pickable = true

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true

func _input(event: InputEvent) -> void:
	# Release anywhere on screen when the mouse button is let go
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		is_dragging = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.x += scroll_left
	if is_dragging:
		var target_pos = get_global_mouse_position() + drag_offset
		# Velocity scales with distance so fast mouse flicks generate fast throw speeds
		velocity = (target_pos - global_position) * drag_responsiveness
		velocity = velocity.limit_length(max_throw_speed)
	else:
		# Apply gravity (if used) and gradually slow down the throw
		velocity.y += gravity * delta 
		velocity.x *= release_friction
		if gravity == 0.0:
			velocity.y *= release_friction
	move_and_slide()
