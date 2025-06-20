@tool
class_name ScoreUI extends Control

@export
var money_label: AmountLabel

@export
var lives_label: AmountLabel

@export
var wave_label: AmountLabel

func set_money(money: int):
	if money_label:
		money_label.amount = money

func set_lives(lives: int):
	if lives_label:
		lives_label.amount = lives

func set_wave(wave: Wave):
	if wave_label:
		wave_label.amount = wave.number
		wave_label.tooltip_text = wave.description
