class_name DuelCallRecord
extends HBoxContainer


const NO_OPPONENT_NAMING = "???"


@onready var _author_nickname_label: Label = %AuthorNicknameLabel
@onready var _opponent_nickname_label: Label = %OpponentNicknameLabel
@onready var _clock_timer: ClockTimer = %ClockTimer

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	alignment = BoxContainer.ALIGNMENT_CENTER


func initialize(duel_call_timer: DuelCallTimer) -> void:
	_initialize_ui(duel_call_timer)

	duel_call_timer.timeout.connect(_on_duel_call_ended)
	duel_call_timer.tree_exited.connect(_on_duel_call_ended)

func _initialize_ui(duel_call_timer: DuelCallTimer) -> void:
	var author_nickname = duel_call_timer.get_author()
	_author_nickname_label.text = author_nickname
	_author_nickname_label.modulate = PlayerManager.get_player_color(author_nickname)

	var opponent_nickname = duel_call_timer.get_opponent()
	if opponent_nickname == Duel.NO_OPPONENT:
		_opponent_nickname_label.text = NO_OPPONENT_NAMING
	else:
		_opponent_nickname_label.text = opponent_nickname
	_opponent_nickname_label.modulate = PlayerManager.get_player_color(opponent_nickname)

	_clock_timer.connect_to_timer(duel_call_timer)


func animate_appear() -> void:
	_animation_player.play("appear")

func _animate_disappear_and_delete() -> void:
	_animation_player.play("disappear")
	await _animation_player.animation_finished
	queue_free()


func _on_duel_call_ended() -> void:
	_animate_disappear_and_delete()
