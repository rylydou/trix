class_name Calc extends RefCounted


static func get_color(num: int) -> Color:
	if num <= 0: return Color.from_ok_hsl(0, 0, .67)
	return Color.from_ok_hsl(hash(num), 1.0, 0.5)


static func get_avg_dir(dirs: PackedVector2Array, weight_curve: Curve) -> Vector2:
	var numer = Vector2.ZERO
	var denom = 0
	
	var index = 0
	for dir in dirs:
		var ratio = float(index) / (dirs.size() - 1)
		var weight = weight_curve.sample_baked(ratio)
		
		numer += dir.normalized() * weight
		denom += weight
		index += 1
	
	return numer / denom

# static func get_avg_dir(points: PackedVector2Array, weight_curve: Curve) -> Vector2:
# 	var numer = Vector2.ZERO
# 	var denom = 0
	
# 	for index in range(points.size() - 1):
# 		var ratio = float(index) / (points.size() - 1)
# 		var weight = weight_curve.sample_baked(ratio)
# 		# weight = 1
		
# 		var point_a = points[index]
# 		var point_b = points[index + 1]
# 		var direction = point_b.direction_to(point_a)
		
# 		numer += direction * weight
# 		denom += weight
	
# 	return numer / denom


static func sqr(x: float) -> float:
	return x * x


static func as_sign(b: bool) -> float:
	return +1.0 if b else -1.0
