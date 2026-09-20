extends RefCounted
class_name CoinFlipGame
#note: strings have to match, that means capitalize heads/tails
static func flip_coin() -> String:
	var result = randi() % 2
	if result == 0:
		return "Heads"
	else:
		return "Tails"
