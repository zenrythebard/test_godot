extends Node2D
var state : int = 0
var toggle : bool = false
var text : bool = false
signal state_changed
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var timer: Timer = $"../Timer"
@onready var text_animation: AnimationPlayer = $"../TextAnimation"
@onready var ascend: Node2D = $"../Text/Ascend"
@onready var descend: Node2D = $"../Text/Descend"

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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if toggle == true:
		descend.visible = true
		ascend.visible = false
	else:
		descend.visible = false
		ascend.visible = true
	if anim_name == "hover_animation" and state == 1:
		text = true
		text_animation.play("text")
