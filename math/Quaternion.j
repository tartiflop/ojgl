#include "Quaternion.h"

#include <math.h>
#include <stdlib.h>

#include "Matrix.h"
#include "Vector.h"

void Quaternion_loadIdentity(Quaternion * quaternion) {
	quaternion->x = 0.0f;
	quaternion->y = 0.0f;
	quaternion->z = 0.0f;
	quaternion->w = 1.0f;
}

Quaternion Quaternion_identity() {
	Quaternion quaternion;
	
	Quaternion_loadIdentity(&quaternion);
	return quaternion;
}

Quaternion Quaternion_withValues(float x, float y, float z, float w) {
	Quaternion quaternion;
	
	quaternion.x = x;
	quaternion.y = y;
	quaternion.z = z;
	quaternion.w = w;
	return quaternion;
}

Quaternion Quaternion_fromVector(Vector vector) {
	Quaternion quaternion;
	
	quaternion.x = vector.x;
	quaternion.y = vector.y;
	quaternion.z = vector.z;
	quaternion.w = 0.0f;
	return quaternion;
}

Vector Quaternion_toVector(Quaternion quaternion) {
	Vector vector;
	
	vector.x = quaternion.x;
	vector.y = quaternion.y;
	vector.z = quaternion.z;
	
	return vector;
}

Quaternion Quaternion_fromAxisAngle(Vector axis, float angle) {
	Quaternion quaternion;
	float sinAngle;
	
	angle *= 0.5f;
	Vector_normalize(&axis);
	sinAngle = sin(angle);
	quaternion.x = (axis.x * sinAngle);
	quaternion.y = (axis.y * sinAngle);
	quaternion.z = (axis.z * sinAngle);
	quaternion.w = cos(angle);
	
	return quaternion;
}

void Quaternion_toAxisAngle(Quaternion quaternion, Vector * axis, float * angle) {
	float sinAngle;
	
	Quaternion_normalize(&quaternion);
	sinAngle = sqrt(1.0f - (quaternion.w * quaternion.w));
	if (fabs(sinAngle) < 0.0005f) sinAngle = 1.0f;
	
	if (axis != NULL) {
		axis->x = (quaternion.x / sinAngle);
		axis->y = (quaternion.y / sinAngle);
		axis->z = (quaternion.z / sinAngle);
	}
	
	if (angle != NULL) {
		*angle = (acos(quaternion.w) * 2.0f);
	}
}

Matrix Quaternion_toMatrix(Quaternion quaternion) {
	Matrix matrix;
	
	matrix.m[0]  = (1.0f - (2.0f * ((quaternion.y * quaternion.y) + (quaternion.z * quaternion.z))));
	matrix.m[1]  =         (2.0f * ((quaternion.x * quaternion.y) + (quaternion.z * quaternion.w)));
	matrix.m[2]  =         (2.0f * ((quaternion.x * quaternion.z) - (quaternion.y * quaternion.w)));
	matrix.m[3]  = 0.0f;
	matrix.m[4]  =         (2.0f * ((quaternion.x * quaternion.y) - (quaternion.z * quaternion.w)));
	matrix.m[5]  = (1.0f - (2.0f * ((quaternion.x * quaternion.x) + (quaternion.z * quaternion.z))));
	matrix.m[6]  =         (2.0f * ((quaternion.y * quaternion.z) + (quaternion.x * quaternion.w)));
	matrix.m[7]  = 0.0f;
	matrix.m[8]  =         (2.0f * ((quaternion.x * quaternion.z) + (quaternion.y * quaternion.w)));
	matrix.m[9]  =         (2.0f * ((quaternion.y * quaternion.z) - (quaternion.x * quaternion.w)));
	matrix.m[10] = (1.0f - (2.0f * ((quaternion.x * quaternion.x) + (quaternion.y * quaternion.y))));
	matrix.m[11] = 0.0f;
	matrix.m[12] = 0.0f;
	matrix.m[13] = 0.0f;
	matrix.m[14] = 0.0f;
	matrix.m[15] = 1.0f;
	
	return matrix;
}

void Quaternion_normalize(Quaternion * quaternion) {
	float magnitude;
	
	magnitude = sqrt((quaternion->x * quaternion->x) +
	                 (quaternion->y * quaternion->y) +
	                 (quaternion->z * quaternion->z) +
	                 (quaternion->w * quaternion->w));
	quaternion->x /= magnitude;
	quaternion->y /= magnitude;
	quaternion->z /= magnitude;
	quaternion->w /= magnitude;
}

Quaternion Quaternion_normalized(Quaternion quaternion) {
	Quaternion_normalize(&quaternion);
	return quaternion;
}

void Quaternion_multiply(Quaternion * quaternion1, Quaternion quaternion2) {
	Vector vector1, vector2, cross;
	float angle;
	
	vector1 = Quaternion_toVector(*quaternion1);
	vector2 = Quaternion_toVector(quaternion2);
	angle = (quaternion1->w * quaternion2.w) - Vector_dot(vector1, vector2);
	
	cross = Vector_cross(vector1, vector2);
	vector1.x *= quaternion2.w;
	vector1.y *= quaternion2.w;
	vector1.z *= quaternion2.w;
	vector2.x *= quaternion1->w;
	vector2.y *= quaternion1->w;
	vector2.z *= quaternion1->w;
	
	quaternion1->x = vector1.x + vector2.x + cross.x;
	quaternion1->y = vector1.y + vector2.y + cross.y;
	quaternion1->z = vector1.z + vector2.z + cross.z;
	quaternion1->w = angle;
}

Quaternion Quaternion_multiplied(Quaternion quaternion1, Quaternion quaternion2) {
	Quaternion_multiply(&quaternion1, quaternion2);
	return quaternion1;
}

#define SLERP_TO_LERP_SWITCH_THRESHOLD 0.01f

Quaternion Quaternion_slerp(Quaternion start, Quaternion end, float alpha) {
	float startWeight, endWeight, difference;
	Quaternion result;
	
	difference = (start.x * end.x) + (start.y * end.y) + (start.z * end.z) + (start.w * end.w);
	if ((1.0f - fabs(difference)) > SLERP_TO_LERP_SWITCH_THRESHOLD) {
		float theta, oneOverSinTheta;
		
		theta = acos(fabs(difference));
		oneOverSinTheta = 1.0f / sin(theta);
		startWeight = sin(theta * (1.0f - alpha)) * oneOverSinTheta;
		endWeight = sin(theta * alpha) * oneOverSinTheta;
		if (difference < 0.0f) {
			startWeight = -startWeight;
		}
	} else {
		startWeight = 1.0f - alpha;
		endWeight = alpha;
	}
	result.x = (start.x * startWeight) + (end.x * endWeight);
	result.y = (start.y * startWeight) + (end.y * endWeight);
	result.z = (start.z * startWeight) + (end.z * endWeight);
	result.w = (start.w * startWeight) + (end.w * endWeight);
	Quaternion_normalize(&result);
	
	return result;
}

void Quaternion_rotate(Quaternion * quaternion, Vector axis, float angle) {
	Quaternion rotationQuaternion;
	
	rotationQuaternion = Quaternion_fromAxisAngle(axis, angle);
	Quaternion_multiply(quaternion, rotationQuaternion);
}

Quaternion Quaternion_rotated(Quaternion quaternion, Vector axis, float angle) {
	Quaternion_rotate(&quaternion, axis, angle);
	return quaternion;
}

void Quaternion_invert(Quaternion * quaternion) {
	float length;
	
	length = 1.0f / ((quaternion->x * quaternion->x) +
	                 (quaternion->y * quaternion->y) +
	                 (quaternion->z * quaternion->z) +
	                 (quaternion->w * quaternion->w));
	quaternion->x *= -length;
	quaternion->y *= -length;
	quaternion->z *= -length;
	quaternion->w *= length;
}

Quaternion Quaternion_inverted(Quaternion quaternion) {
	Quaternion_invert(&quaternion);
	return quaternion;
}

Vector Quaternion_multiplyVector(Quaternion quaternion, Vector vector) {
	Quaternion vectorQuaternion, inverseQuaternion, result;
	
	vectorQuaternion = Quaternion_fromVector(vector);
	inverseQuaternion = Quaternion_inverted(quaternion);
	result = Quaternion_multiplied(quaternion, Quaternion_multiplied(vectorQuaternion, inverseQuaternion));
	return Quaternion_toVector(result);
}
