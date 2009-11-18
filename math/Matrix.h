#define degreesToRadians(degrees) (((degrees) * M_PI) / 180.0) 
#define radiansToDegrees(radians) (((radians) * 180.0) / M_PI) 


/*
#define _CGPointMake(x_, y_) { x:x_, y:y_ }
#define _CGPointMakeCopy(aPoint) _CGPointMake(aPoint.x, aPoint.y)
#define _CGPointEqualToPoint(lhsPoint, rhsPoint) (lhsPoint.x == rhsPoint.x && lhsPoint.y == rhsPoint.y)
#define _CGStringFromPoint(aPoint) ("{" + aPoint.x + ", " + aPoint.y + "}")
#define _CGSizeMakeZero() _CGSizeMake(0.0, 0.0)
#define _CGSizeEqualToSize(lhsSize, rhsSize) (lhsSize.width == rhsSize.width && lhsSize.height == rhsSize.height)
#define _CGRectMake(x, y, width, height) { origin: _CGPointMake(x, y), size: _CGSizeMake(width, height) }
#define _CGRectGetHeight(aRect) (aRect.size.height)
#define _CGRectGetMaxX(aRect) (aRect.origin.x + aRect.size.width)
#define _CGRectIsEmpty(aRect) (aRect.size.width <= 0.0 || aRect.size.height <= 0.0)
#define _CGInsetIsEmpty(anInset) ((anInset).top === 0 && (anInset).right === 0 && (anInset).bottom === 0 && (anInset).left === 0)
*/
/*
struct Vector;

struct Matrix {
	float m[16];
};

void Matrix_loadIdentity(Matrix * matrix1);
Matrix Matrix_identity();

Matrix Matrix_withValues(float m0,  float m4,  float m8,  float m12,
                         float m1,  float m5,  float m9,  float m13,
                         float m2,  float m6,  float m10, float m14,
                         float m3,  float m7,  float m11, float m15);
Matrix Matrix_fromDirectionVectors(struct Vector right, struct Vector up, struct Vector front);

void Matrix_multiply(Matrix * matrix1, Matrix matrix2);
Matrix Matrix_multiplied(Matrix matrix1, Matrix matrix2);

void Matrix_translate(Matrix * matrix1, float x, float y, float z);
Matrix Matrix_translated(Matrix matrix1, float x, float y, float z);

void Matrix_scale(Matrix * matrix, float x, float y, float z);
Matrix Matrix_scaled(Matrix matrix, float x, float y, float z);

void Matrix_rotate(Matrix * matrix, struct Vector axis, float angle);
Matrix Matrix_rotated(Matrix matrix, struct Vector axis, float angle);

void Matrix_shearX(Matrix * matrix, float y, float z);
Matrix Matrix_shearedX(Matrix matrix, float y, float z);

void Matrix_shearY(Matrix * matrix, float x, float z);
Matrix Matrix_shearedY(Matrix matrix, float x, float z);

void Matrix_shearZ(Matrix * matrix, float x, float y);
Matrix Matrix_shearedZ(Matrix matrix, float x, float y);

void Matrix_applyPerspective(Matrix * matrix, float fovY, float aspect, float zNear, float zFar);
Matrix Matrix_perspective(Matrix matrix, float fovY, float aspect, float zNear, float zFar);

void Matrix_transpose(Matrix * matrix);
Matrix Matrix_transposed(Matrix matrix);

float Matrix_determinant(Matrix matrix);

void Matrix_invert(Matrix * matrix);
Matrix Matrix_inverted(Matrix matrix);

struct Vector Matrix_multiplyVector(Matrix matrix, struct Vector vector);

*/
