class_name DuelQueueList
extends VBoxContainer


const DUEL_QUEUE_RECORD = preload("uid://dgyqhhd2xpifm")


@export var _duel_queue_manager: DuelQueueManager


@onready var _title_label: Label = $TitleLabel
@onready var _record_container: VBoxContainer = %RecordContainer


func _ready() -> void:
	_title_label.text = Locale.NO_QUEUED_DUELS

	_duel_queue_manager.added_pair.connect(_on_added_pair)
	_duel_queue_manager.removed_pair.connect(_on_removed_pair)


func _on_added_pair(duel_pair: DuelPair) -> void:
	var duel_queue_record = DUEL_QUEUE_RECORD.instantiate() as DuelQueueRecord
	_record_container.add_child(duel_queue_record)

	duel_queue_record.initialize(duel_pair)
	duel_queue_record.animate_appear()

	_update_title()

func _on_removed_pair(duel_pair: DuelPair) -> void:
	## В нормальных условиях всегда сработает первый. Просто защищаемся от предположений.
	for child in _record_container.get_children():
		var record = child as DuelQueueRecord
		if record.belongs_to_pair(duel_pair):
			record.animate_disappear_and_delete()
			await record.tree_exited
			_update_title()
			break

func _update_title() -> void:
	_title_label.text = Locale.QUEUED_DUELS if _has_records() else Locale.NO_QUEUED_DUELS

func _has_records() -> bool:
	return _record_container.get_child_count() > 0
