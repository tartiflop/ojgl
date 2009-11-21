
function Vector_withValues( x, y, z) {
	var vector = {};
	
	vector.x = x;
	vector.y = y;
	vector.z = z;
	return vector;
}

function Vector_withVector( vector) {
    var result = {};

	result.x = matrix.x;
	result.y = matrix.y;
	result.z = matrix.z;
    return result;
}

function Vector_normalize( vector) {
	var magnitude;
	
	magnitude = Math.sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));
	vector.x /= magnitude;
	vector.y /= magnitude;
	vector.z /= magnitude;
}

function Vector_normalized( vector) {
	Vector_normalize(vector);
	return vector;
}

function Vector_magnitude( vector) {
	return sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));
}

function Vector_magnitudeSquared( vector) {
	return ((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));
}

function Vector_add( vector1,  vector2) {
	return Vector_withValues((vector1.x + vector2.x), (vector1.y + vector2.y), (vector1.z + vector2.z));
}

function Vector_subtract( vector1,  vector2) {
	return Vector_withValues((vector1.x - vector2.x), (vector1.y - vector2.y), (vector1.z - vector2.z));
}

function Vector_dot( vector1,  vector2) {
	return ((vector1.x * vector2.x) + (vector1.y * vector2.y) + (vector1.z * vector2.z));
}

function Vector_cross( vector1,  vector2) {
	var result = {};
	
	result.x = ((vector1.y * vector2.z) - (vector1.z * vector2.y));
	result.y = ((vector1.z * vector2.x) - (vector1.x * vector2.z));
	result.z = ((vector1.x * vector2.y) - (vector1.y * vector2.x));
	return result;
}
