class_name NumberFormatter

static func abbreviate(n: int) -> String:
	if n >= 1_000_000_000_000:
		# ran for every number <n> greater or equal to a trillion
		var snapped_amount := floor_to(n, 1_000_000_000_000)
		if snapped_amount > n:
			snapped_amount -= 0.01

		return str(snapped_amount).replace(",", ".") + "T"

	if n >= 1_000_000_000:
		# ran for every number <n> greater or equal to a trillion BUT
		# still greater or equal to 1 billion
		var snapped_amount := floor_to(n, 1_000_000_000)
		if snapped_amount > n:
			snapped_amount -= 0.01

		return str(snapped_amount).replace(",", ".") + "B"

	if n >= 1_000_000:
		# ran for every number <n> smaller than 1 billion BUT
		# still greater or equal to 1 million
		var snapped_amount := floor_to(n, 1_000_000)
		if snapped_amount > n:
			snapped_amount -= 0.01

		return str(snapped_amount).replace(",", ".") + "M"

	if n >= 1_000:
		# ran for every number <n> smaller than 1 million BUT
		# still greater or equal to 1 thousand
		var snapped_amount := floor_to(n, 1_000)
		return str(snapped_amount).replace(",", ".") + "k"

	return str(n)

static func floor_to(n: int, denominator: int) -> float:
	var to_snap := float(n) / denominator
	var snapped_amount := snappedf(to_snap, 0.01)

	# subtract, if it got rounded up
	if snapped_amount > to_snap:
		snapped_amount -= 0.01

	return snapped_amount
