extends Node2D
var state : int = 0
var text : bool = false
signal state_changed
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var timer: Timer = $"../Timer"
@onready var text_animation: AnimationPlayer = $"../TextAnimation"

func _ready() -> void:
	state_changed.connect(on_state_changed)
	state = 0
	animation_player.play("idle_animation")

func on_state_changed():
	if text == true and state !=1:
				text_animation.play("text_exit")
				text = false
	print(state)
	match state: 
		0: 
			return
		1: animation_player.play("hover_animation")
		2: 
			animation_player.play("hover_to_neutral_animation")
		3: 
			animation_player.play("click_animation")
			await get_tree().create_timer(2).timeout
			state = 4
			emit_signal("state_changed")
		4:
			animation_player.play("click_to_neutral_animation")
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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hover_animation" and state == 1:
		text = true
		text_animation.play("text")
