extends Node2D
var state : int = 0
signal state_changed
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _ready() -> void:
	state_changed.connect(on_state_changed)
	state = 0
	emit_signal("state_changed")

func on_state_changed():
	print(state)
	match state: 
		0: 
			return
		1: animation_player.play("hover_animation")
		2: 
			animation_player.play("hover_to_neutral_animation")
			await get_tree().create_timer(6).timeout
			state = 0
			emit_signal("state_changed")
		3: 
			animation_player.play("click_animation")
			await get_tree().create_timer(2).timeout
			state = 4
			emit_signal("state_changed")
		4:
			animation_player.play("click_to_neutral_animation")
			await get_tree().create_timer(2).timeout
			state = 0
			emit_signal("state_changed")
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
