#ifndef __QUATERNION_H__
#define __QUATERNION_H__

typedef struct Quaternion Quaternion;

struct Vector;
struct Matrix;

struct Quaternion {
	float x;
	float y;
	float z;
	float w;
};

void Quaternion_loadIdentity(Quaternion * quaternion);
Quaternion Quaternion_identity();
Quaternion Quaternion_withValues(float x, float y, float z, float w);

Quaternion Quaternion_fromVector(struct Vector vector);
struct Vector Quaternion_toVector(Quaternion quaternion);
Quaternion Quaternion_fromAxisAngle(struct Vector axis, float angle);
void Quaternion_toAxisAngle(Quaternion quaternion, struct Vector * axis, float * angle);
struct Matrix Quaternion_toMatrix(Quaternion quaternion);

void Quaternion_normalize(Quaternion * quaternion);
Quaternion Quaternion_normalized(Quaternion quaternion);

void Quaternion_multiply(Quaternion * quaternion1, Quaternion quaternion2);
Quaternion Quaternion_multiplied(Quaternion quaternion1, Quaternion quaternion2);
Quaternion Quaternion_slerp(Quaternion start, Quaternion end, float alpha);

void Quaternion_rotate(Quaternion * quaternion, struct Vector axis, float angle);
Quaternion Quaternion_rotated(Quaternion quaternion, struct Vector axis, float angle);

void Quaternion_invert(Quaternion * quaternion);
Quaternion Quaternion_inverted(Quaternion quaternion);

struct Vector Quaternion_multiplyVector(Quaternion quaternion, struct Vector vector);

#endif
