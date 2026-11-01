class_name DuelQueueRecord
extends HBoxContainer


var _duel_pair: DuelPair

@onready var _first_player_nickname_label: Label = %FirstPlayerNicknameLabel
@onready var _second_player_nickname_label: Label = %SecondPlayerNicknameLabel
@onready var _animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER


func belongs_to_pair(duel_pair: DuelPair) -> bool:
	return _duel_pair == duel_pair

func initialize(duel_pair: DuelPair) -> void:
	_duel_pair = duel_pair

	_initialize_ui()

func _initialize_ui() -> void:
	_first_player_nickname_label.text = _duel_pair.first_player.nickname
	_first_player_nickname_label.modulate = _duel_pair.first_player.color

	_second_player_nickname_label.text = _duel_pair.second_player.nickname
	_second_player_nickname_label.modulate = _duel_pair.second_player.color

func animate_appear() -> void:
	_animation_player.play("appear")

func animate_disappear_and_delete() -> void:
	_animation_player.play("disappear")
	await _animation_player.animation_finished
	queue_free()
