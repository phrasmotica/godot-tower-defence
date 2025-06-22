@tool
class_name ScoreUI extends Control

@export
var money_label: AmountLabel

@export
var lives_label: AmountLabel

@export
var wave_label: AmountLabel

func _ready() -> void:
	if not Engine.is_editor_hint():
		BankManager.money_changed.connect(_on_bank_manager_money_changed)

		LivesManager.lives_changed.connect(_on_lives_manager_lives_changed)

		WavesManager.wave_sent.connect(_on_waves_manager_wave_sent)

func _on_bank_manager_money_changed(new_money: int) -> void:
	set_money(new_money)

func _on_lives_manager_lives_changed(new_lives: int) -> void:
	set_lives(new_lives)

func _on_waves_manager_wave_sent(wave: Wave) -> void:
	set_wave(wave)

func set_money(money: int) -> void:
	if money_label:
		money_label.amount = money

func set_lives(lives: int) -> void:
	if lives_label:
		lives_label.amount = lives

func set_wave(wave: Wave) -> void:
	if wave_label:
		wave_label.amount = wave.number
		wave_label.tooltip_text = wave.description
