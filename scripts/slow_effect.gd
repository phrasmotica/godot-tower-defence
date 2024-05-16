class_name SlowEffect extends Effect

func act_start():
    print("Slowing enemy START")
    enemy.movement_speed /= 2

func act_end():
    print("Slowing enemy END")
    enemy.movement_speed *= 2
