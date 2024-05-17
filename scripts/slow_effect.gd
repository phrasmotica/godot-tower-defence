class_name SlowEffect extends Effect

func act_start():
    print("Slowing enemy START")
    attached_enemy.is_slowed = true
    attached_enemy.movement_speed /= 2

func act_end():
    print("Slowing enemy END")
    attached_enemy.movement_speed *= 2
    attached_enemy.is_slowed = false

func can_act(enemy: Enemy):
    return not enemy.is_slowed
