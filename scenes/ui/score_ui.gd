@tool
class_name ScoreUI extends MarginContainer

@onready
var money_label: AmountLabel = %MoneyLabel

@onready
var lives_label: AmountLabel = %LivesLabel

@onready
var wave_label: AmountLabel = %WaveLabel

func _ready() -> void:
	if not Engine.is_editor_hint():
		BankManager.money_changed.connect(_on_bank_manager_money_changed)

		LivesManager.lives_changed.connect(_on_lives_manager_lives_changed)

		WaveEvents.wave_sent.connect(_on_wave_sent)

		set_money(BankManager.get_money())
		set_lives(LivesManager.get_lives())

func _on_bank_manager_money_changed(_old_money: int, new_money: int) -> void:
	set_money(new_money)

func _on_lives_manager_lives_changed(new_lives: int) -> void:
	set_lives(new_lives)

func _on_wave_sent(wave: Wave) -> void:
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
