class_name Utility extends Node


static func value_to_percent(value:float, total) -> float:
	return (value / total) * 100 if total != 0 else 0

static func percent_to_value(percent, total) -> float:
	return (percent / 100) * total if total != 0 else 0
