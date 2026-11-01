class_name CommandManager
extends Node


@export var _duel_call_manager: DuelCallManager
@export var _command_transmitter: CommandTransmitter


func _ready() -> void:
	CommandParser.duel_call.connect(_on_duel_call)
	CommandParser.symbol_placed.connect(_on_symbol_placed)
	CommandParser.changed_color.connect(_on_color_change)


func _on_duel_call(author: String, opponent: String) -> void:
	_duel_call_manager.try_add_call(author, opponent)


func _on_symbol_placed(author: String, coordinate: Vector2i) -> void:
	_command_transmitter.transmit_symbol_placement(author, coordinate)


func _on_color_change(author: String, color: Color) -> void:
	var existing_player = PlayerManager.get_player(author)
	if not existing_player:
		return

	existing_player.color = color
