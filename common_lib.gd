
static func array_copy(arr):
	var copy = Array()
	for i in range(arr.size()):
		copy.append(arr[i])
		
	return copy
	
static func array_copy2d(arr):
	var copy = Array()
	for i in range(arr.size()):
		copy.append([])
		for j in range(arr[i].size()):
			copy[i].append(arr[i][j])
		
	return copy
	
static func array2d_contains(arr, value):
	for i in range(arr.size()):
		for j in range(arr[i].size()):
			if (value == arr[i][j]):
				return true
	return false

static func is_in_range(value, base, res):
	return value <= base + res && value >= base - res