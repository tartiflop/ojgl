@import <Foundation/CPObject.j>

@implementation GLMatrix : CPObject {
	float _m11;
	float _m12;
	float _m13;
	float _m14;
	float _m21;
	float _m22;
	float _m23;
	float _m24;
	float _m31;
	float _m32;
	float _m33;
	float _m34;
	float _m41;
	float _m42;
	float _m43;
	float _m44;
}

- (id)init {
	self = [super init];
	
	if (self) {
		// init with uniform matrix
		_m11 = 1;
		_m12 = 0;
		_m13 = 0;
		_m14 = 0;
		_m21 = 0;
		_m22 = 1;
		_m23 = 0;
		_m24 = 0;
		_m31 = 0;
		_m32 = 0;
		_m33 = 1;
		_m34 = 0;
		_m41 = 0;
		_m42 = 0;
		_m43 = 0;
		_m44 = 1;
	}
 	
	return self;
}


- (id)initWithTranslation:(float)x y:(float)y z:(float)z {
	self = [super init];
	
	if (self) {
		if (x == undefined) {
			x = 0;
		}
		if (y == undefined) {
			y = 0;
		}
		if (z == undefined) {
			z = 0;
		}

		_m11 = 1;
		_m12 = 0;
		_m13 = 0;
		_m14 = 0;
		_m21 = 0;
		_m22 = 1;
		_m23 = 0;
		_m24 = 0;
		_m31 = 0;
		_m32 = 0;
		_m33 = 1;
		_m34 = 0;
		_m41 = x;
		_m42 = y;
		_m43 = z;
		_m44 = 1;
	}
 	
	return self;
}


- (id)initWithRotation:(float)angle x:(float)x y:(float)y z:(float)z {

	self = [super init];
	
	if (self) {

		// angles are in degrees. Switch to radians
		angle = angle / 180 * Math.PI;
		
		angle /= 2;
		var sinA = Math.sin(angle);
		var cosA = Math.cos(angle);
		var sinA2 = sinA * sinA;
		
		// normalize
		var length = Math.sqrt(x * x + y * y + z * z);
		if (length == 0) {
			// bad vector, just use something reasonable
			x = 0;
			y = 0;
			z = 1;
		} else if (length != 1) {
			x /= length;
			y /= length;
			z /= length;
		}
		
		// optimize case where axis is along major axis
		if (x == 1 && y == 0 && z == 0) {
			_m11 = 1;
			_m12 = 0;
			_m13 = 0;
			_m21 = 0;
			_m22 = 1 - 2 * sinA2;
			_m23 = 2 * sinA * cosA;
			_m31 = 0;
			_m32 = -2 * sinA * cosA;
			_m33 = 1 - 2 * sinA2;
			_m14 = _m24 = _m34 = 0;
			_m41 = _m42 = _m43 = 0;
			_m44 = 1;
		} else if (x == 0 && y == 1 && z == 0) {
			_m11 = 1 - 2 * sinA2;
			_m12 = 0;
			_m13 = -2 * sinA * cosA;
			_m21 = 0;
			_m22 = 1;
			_m23 = 0;
			_m31 = 2 * sinA * cosA;
			_m32 = 0;
			_m33 = 1 - 2 * sinA2;
			_m14 = _m24 = _m34 = 0;
			_m41 = _m42 = _m43 = 0;
			_m44 = 1;
		} else if (x == 0 && y == 0 && z == 1) {
			_m11 = 1 - 2 * sinA2;
			_m12 = 2 * sinA * cosA;
			_m13 = 0;
			_m21 = -2 * sinA * cosA;
			_m22 = 1 - 2 * sinA2;
			_m23 = 0;
			_m31 = 0;
			_m32 = 0;
			_m33 = 1;
			_m14 = _m24 = _m34 = 0;
			_m41 = _m42 = _m43 = 0;
			_m44 = 1;
		} else {
			var x2 = x*x;
			var y2 = y*y;
			var z2 = z*z;
		
			_m11 = 1 - 2 * (y2 + z2) * sinA2;
			_m12 = 2 * (x * y * sinA2 + z * sinA * cosA);
			_m13 = 2 * (x * z * sinA2 - y * sinA * cosA);
			_m21 = 2 * (y * x * sinA2 - z * sinA * cosA);
			_m22 = 1 - 2 * (z2 + x2) * sinA2;
			_m23 = 2 * (y * z * sinA2 + x * sinA * cosA);
			_m31 = 2 * (z * x * sinA2 + y * sinA * cosA);
			_m32 = 2 * (z * y * sinA2 - x * sinA * cosA);
			_m33 = 1 - 2 * (x2 + y2) * sinA2;
			_m14 = _m24 = _m34 = 0;
			_m41 = _m42 = _m43 = 0;
			_m44 = 1;
		}
	}
	
	return self;
}


- (id)initWithFrustum:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far {

	self = [super init];
	
	if (self) {

		var A = (right + left) / (right - left);
		var B = (top + bottom) / (top - bottom);
		var C = -(far + near) / (far - near);
		var D = -(2 * far * near) / (far - near);
		
		_m11 = (2 * near) / (right - left);
		_m12 = 0;
		_m13 = 0;
		_m14 = 0;
		
		_m21 = 0;
		_m22 = 2 * near / (top - bottom);
		_m23 = 0;
		_m24 = 0;
		
		_m31 = A;
		_m32 = B;
		_m33 = C;
		_m34 = -1;
		
		_m41 = 0;
		_m42 = 0;
		_m43 = D;
		_m44 = 0;
	}
	
	return self;
}



- (id)initWithLookat:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz { 
	self = [super init];
	
	if (self) {
		// Make rotation matrix
	
		// Z vector
		var zx = eyex - centerx;
		var zy = eyey - centery;
		var zz = eyez - centerz;
		var mag = Math.sqrt(zx * zx + zy * zy + zz * zz);
		if (mag) {
			zx /= mag;
			zy /= mag;
			zz /= mag;
		}
	
		// Y vector
		var yx = upx;
		var yy = upy;
		var yz = upz;
	
		// X vector = Y cross Z
		xx =  yy * zz - yz * zy;
		xy = -yx * zz + yz * zx;
		xz =  yx * zy - yy * zx;
	
		// Recompute Y = Z cross X
		yx = zy * xz - zz * xy;
		yy = -zx * xz + zz * xx;
		yx = zx * xy - zy * xx;
	
		// cross product gives area of parallelogram, which is < 1.0 for
		// non-perpendicular unit-length vectors; so normalize x, y here
	
		mag = Math.sqrt(xx * xx + xy * xy + xz * xz);
		if (mag) {
			xx /= mag;
			xy /= mag;
			xz /= mag;
		}
	
		mag = Math.sqrt(yx * yx + yy * yy + yz * yz);
		if (mag) {
			yx /= mag;
			yy /= mag;
			yz /= mag;
		}
	
		_m11 = xx;
		_m12 = xy;
		_m13 = xz;
		_m14 = 0;
		
		_m21 = yx;
		_m22 = yy;
		_m23 = yz;
		_m24 = 0;
		
		_m31 = zx;
		_m32 = zy;
		_m33 = zz;
		_m34 = 0;
		
		_m41 = 0;
		_m42 = 0;
		_m43 = 0;
		_m44 = 1;
		
		[self translate:-eyex y:-eyey z:-eyez];
	}
	
	return self;
}


- (id)initWithPerspective:(float)fovy aspect:(float)aspect zNear:(float)zNear zFar:(float)zFar {
	var top = Math.tan(fovy * Math.PI / 360) * zNear;
	var bottom = -top;
	var left = aspect * bottom;
	var right = aspect * top;

	return [self initWithFrustum:left right:right bottom:bottom top:top near:zNear far:zFar];
}


- (Array)getAsArray {
	return [
			_m11, _m12, _m13, _m14, 
			_m21, _m22, _m23, _m24, 
			_m31, _m32, _m33, _m34, 
			_m41, _m42, _m43, _m44
		];
}

- (Array)getAsCanvasFloatArray {
	return new CanvasFloatArray([
			_m11, _m12, _m13, _m14, 
			_m21, _m22, _m23, _m24, 
			_m31, _m32, _m33, _m34, 
			_m41, _m42, _m43, _m44
		]);
}


- (void)translate:(float)x y:(float)y z:(float)z {
	
	var translationMatrix = [[GLMatrix alloc] initWithTranslation:x y:y z:z];

	[self multiply:translationMatrix];
}



- (void)rotate:(float)angle x:(float)x y:(float)y z:(float)z {

	var rotationMatrix = [[GLMatrix alloc] initWithRotation:angle x:x y:y z:z];
	
	[self multiply:rotationMatrix];
}


- (void)frustum:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far  {
	var frustumMatrix = [[GLMatrix alloc] initWithFrustum:left right:right bottom:bottom top:top near:near far:far];
	
	[self multiply:frustumMatrix];
}

- (void)perspective:(float)fovy aspect:(float)aspect zNear:(float)zNear zFar:(float)zFar {
	var top = Math.tan(fovy * Math.PI / 360) * zNear;
	var bottom = -top;
	var left = aspect * bottom;
	var right = aspect * top;
	
	[self frustum:left right:right bottom:bottom top:top near:zNear far:zFar];
}



- (void)lookat:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz {
	var lookatMatrix = [[GLMatrix alloc] initWithLookat:eyex eyey:eyey eyez:eyez centerx:centerx centery:centery centerz:centerz upx:upx upy:upy upz:upz];
	
	return [self multiply:lookatMatrix];
}


- (GLMatrix)multiply:(GLMatrix)matrix {
	

	var matrixArray = [matrix getAsArray];
	var matM11 = matrixArray[0];
	var matM12 = matrixArray[1];
	var matM13 = matrixArray[2];
	var matM14 = matrixArray[3];
	var matM21 = matrixArray[4];
	var matM22 = matrixArray[5];
	var matM23 = matrixArray[6];
	var matM24 = matrixArray[7];
	var matM31 = matrixArray[8];
	var matM32 = matrixArray[9];
	var matM33 = matrixArray[10];
	var matM34 = matrixArray[11];
	var matM41 = matrixArray[12];
	var matM42 = matrixArray[13];
	var matM43 = matrixArray[14];
	var matM44 = matrixArray[15];
	
	
	var m11 = (_m11 * matM11 + _m12 * matM21 + _m13 * matM31 + _m14 * matM41);
	var m12 = (_m11 * matM12 + _m12 * matM22 + _m13 * matM32 + _m14 * matM42);
	var m13 = (_m11 * matM13 + _m12 * matM23 + _m13 * matM33 + _m14 * matM43);
	var m14 = (_m11 * matM14 + _m12 * matM24 + _m13 * matM34 + _m14 * matM44);

	var m21 = (_m21 * matM11 + _m22 * matM21 + _m23 * matM31 + _m24 * matM41);
	var m22 = (_m21 * matM12 + _m22 * matM22 + _m23 * matM32 + _m24 * matM42);
	var m23 = (_m21 * matM13 + _m22 * matM23 + _m23 * matM33 + _m24 * matM43);
	var m24 = (_m21 * matM14 + _m22 * matM24 + _m23 * matM34 + _m24 * matM44);

	var m31 = (_m31 * matM11 + _m32 * matM21 + _m33 * matM31 + _m34 * matM41);
	var m32 = (_m31 * matM12 + _m32 * matM22 + _m33 * matM32 + _m34 * matM42);
	var m33 = (_m31 * matM13 + _m32 * matM23 + _m33 * matM33 + _m34 * matM43);
	var m34 = (_m31 * matM14 + _m32 * matM24 + _m33 * matM34 + _m34 * matM44);

	var m41 = (_m41 * matM11 + _m42 * matM21 + _m43 * matM31 + _m44 * matM41);
	var m42 = (_m41 * matM12 + _m42 * matM22 + _m43 * matM32 + _m44 * matM42);
	var m43 = (_m41 * matM13 + _m42 * matM23 + _m43 * matM33 + _m44 * matM43);
	var m44 = (_m41 * matM14 + _m42 * matM24 + _m43 * matM34 + _m44 * matM44);
	
	_m11 = m11;
	_m12 = m12;
	_m13 = m13;
	_m14 = m14;
	
	_m21 = m21;
	_m22 = m22;
	_m23 = m23;
	_m24 = m24;
	
	_m31 = m31;
	_m32 = m32;
	_m33 = m33;
	_m34 = m34;
	
	_m41 = m41;
	_m42 = m42;
	_m43 = m43;
	_m44 = m44;
}

@end
