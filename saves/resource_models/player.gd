class_name Player
extends Resource

const LAST_DUEL_RESULTS_LIMIT = 10


@export var nickname: String
@export var color: Color

@export var wins: int = 0
@export var loses: int = 0
@export var ties: int = 0

@export var _last_duel_results: Array[Duel.Result]


func get_match_count() -> int:
	return wins + loses + ties

func add_duel_result(result: Duel.Result) -> void:
	match result:
		Duel.Result.WIN:
			wins += 1
		Duel.Result.LOSE:
			loses += 1
		Duel.Result.TIE:
			ties += 1

	_last_duel_results.push_front(result)
	if _last_duel_results.size() >= LAST_DUEL_RESULTS_LIMIT:
		_last_duel_results.resize(LAST_DUEL_RESULTS_LIMIT)

func get_last_wins_percentage() -> float:
	## И сразу предотвращаем деление на ноль
	if _last_duel_results.is_empty():
		return 0

	var win_count = float(_last_duel_results.count(Duel.Result.WIN))
	## Делим на текущий размер, так как пользователь мог только начать играть.
	return win_count / _last_duel_results.size()

static func who_wins_less(first: Player, second: Player) -> Player:
	var first_wins = first.get_last_wins_percentage()
	var second_wins = second.get_last_wins_percentage()
	if first_wins > second_wins:
		return second
	elif second_wins > first_wins:
		return first

	return null
