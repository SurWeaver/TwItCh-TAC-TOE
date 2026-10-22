class_name PlayerName
extends Label


const HIDDEN: float = 0.0
const VISIBLE: float = 1.0


@export var _alpha_change_animation_duration: float = 0.5

@export var _highlight_scale: float = 1.5
@export var _scale_change_animation_duration: float = 0.3


func _ready() -> void:
	modulate = Color.TRANSPARENT
	pivot_offset_ratio = Vector2(0.5, 0.5)
	offset_transform_enabled = true

func set_player(player: Player) -> void:
	text = player.nickname
	modulate = Color(player.color, modulate.a)

func show_player() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", VISIBLE, _alpha_change_animation_duration)

func hide_player() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", HIDDEN, _alpha_change_animation_duration)


func highlight() -> void:
	var tween = create_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE * _highlight_scale, _scale_change_animation_duration)

func dehighlight() -> void:
	var tween = create_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, _scale_change_animation_duration)
