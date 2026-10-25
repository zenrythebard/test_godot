extends Node2D
var state : int = 0
var toggle : bool = false
signal state_changed
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var timer: Timer = $"../Timer"

func _ready() -> void:
	state_changed.connect(on_state_changed)
	state = 0
	animation_player.play("idle_animation")

func on_state_changed():
	print(state)
	match state: 
		0: 
			return
		1: animation_player.play("hover_animation")
		2: 
			animation_player.play("hover_to_neutral_animation")
		3: 
			if toggle:
				animation_player.play("descend_to_ascend")
				await get_tree().create_timer(1).timeout
				toggle = false
				state = 0
			else:
				animation_player.play("ascend_to_descend")
				await get_tree().create_timer(1).timeout
				toggle = true
				state = 0
	print(animation_player.current_animation)

func _on_button_pressed() -> void:
	if state == 3:
		return
	state = 3
	emit_signal("state_changed")
	
func _on_button_mouse_entered() -> void:
	if state == 1 or state == 3:
		return
	state = 1
	emit_signal("state_changed")

func _on_button_mouse_exited() -> void:
	if state != 1:
		return
	state = 2
	emit_signal("state_changed")
