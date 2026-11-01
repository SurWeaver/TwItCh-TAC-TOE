extends Control


const DUEL_CALL_RECORD = preload("uid://b8hl6wxuf5xsb")


@export var _duel_call_manager: DuelCallManager

@onready var _title_label: Label = $TitleLabel
@onready var _record_container: VBoxContainer = %RecordContainer


func _ready() -> void:
	_duel_call_manager.call_created.connect(_on_duel_call_created)


func _on_duel_call_created(timer: DuelCallTimer) -> void:
	var record = DUEL_CALL_RECORD.instantiate() as DuelCallRecord

	_record_container.add_child(record)
	record.initialize(timer)

	record.animate_appear()
	record.tree_exited.connect(_update_title)

	_update_title()

func _update_title() -> void:
	_title_label.text = Locale.DUEL_CALLS if _has_records() else Locale.NO_DUEL_CALLS

func _has_records() -> bool:
	return _record_container.get_child_count() > 0
