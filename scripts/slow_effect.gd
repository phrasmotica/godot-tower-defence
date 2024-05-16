class_name SlowEffect extends Effect

func act_start():
    enemy.movement_speed /= 2

func act_end():
    enemy.movement_speed *= 2
