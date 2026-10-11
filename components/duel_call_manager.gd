class_name DuelCallManager
extends Node


signal opponents_matched(first_player: String, second_player: String)

signal call_created(timer: DuelCallTimer)


func try_add_call(author: String, opponent: String = "") -> void:
	## Если у автора уже есть вызов, удаляем старый
	var author_timer = _get_timer_by_author(author)
	if author_timer:
		author_timer.queue_free()

	if opponent == Constants.NO_OPPONENT:
		_process_no_opponent_call(author)
	else:
		_process_opponent_call(author, opponent)


func _process_no_opponent_call(author: String) -> void:
	## Ответ на существующий вызов, адресованный к текущему автору
	var existing_call_timer = _get_timer_by_opponent(author)
	if existing_call_timer:
		_answer_call(existing_call_timer, author)
		return

	## Ответ на существующий вызов, не адресованный никому
	var no_opponent_timer = _get_no_opponent_timer()
	if no_opponent_timer:
		_answer_call(no_opponent_timer, author)
		return

	_create_call(author, Constants.NO_OPPONENT)

func _process_opponent_call(author: String, opponent: String) -> void:
	## Ответ на вызов, адресованный конкретно автору
	var mirror_call = _get_certain_timer(opponent, author)
	if mirror_call:
		_answer_call(mirror_call, author)
		return

	## Ответ на существующий вызов, не адресованный никому
	var random_opponent_call = _get_certain_timer(opponent, Constants.NO_OPPONENT)
	if random_opponent_call:
		_answer_call(random_opponent_call, author)
		return

	_create_call(author, opponent)


func _answer_call(timer: DuelCallTimer, respondent_player: String) -> void:
	timer.stop()
	## Ставим первым игроком того, кто уже ждал ответа на вызов
	opponents_matched.emit(timer.get_author(), respondent_player)
	timer.queue_free()
	_remove_unanswered_calls(timer.get_author(), respondent_player)

func _create_call(author: String, opponent: String) -> void:
	var timer = DuelCallTimer.new(author, opponent)
	add_child(timer)
	call_created.emit(timer)


func _get_timer_by_author(author: String) -> DuelCallTimer:
	var timer: DuelCallTimer
	for child in get_children():
		if child.is_queued_for_deletion():
			continue
		timer = child as DuelCallTimer
		if timer.get_author() == author:
			return timer
	return null

func _get_timer_by_opponent(opponent: String) -> DuelCallTimer:
	var timer: DuelCallTimer
	for child in get_children():
		if child.is_queued_for_deletion():
			continue
		timer = child as DuelCallTimer
		if timer.get_opponent() == opponent:
			return timer
	return null

func _get_no_opponent_timer() -> DuelCallTimer:
	var timer: DuelCallTimer
	for child in get_children():
		if child.is_queued_for_deletion():
			continue
		timer = child as DuelCallTimer
		if not timer.has_concrete_opponent():
			return timer
	return null

func _get_certain_timer(author: String, opponent: String) -> DuelCallTimer:
	var timer: DuelCallTimer
	for child in get_children():
		if child.is_queued_for_deletion():
			continue
		timer = child as DuelCallTimer
		if timer.get_author() == author and timer.get_opponent() == opponent:
			return timer
	return null


func _remove_unanswered_calls(first_player: String, second_player: String) -> void:
	var timer: DuelCallTimer
	for child in get_children():
		timer = child as DuelCallTimer
		if timer.has_participant(first_player) or timer.has_participant(second_player):
			timer.queue_free()
