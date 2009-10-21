@import <Foundation/CPObject.j>


/**
 * A 3D transformation 4x4 matrix
 */
@implementation Matrix3D : CPObject {

	/**
	 * The value in the first row and first column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _sxx @accessors(property=sxx);
	
	/**
	 * The value in the first row and second column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _sxy @accessors(property=sxy);
	
	/**
	 * The value in the first row and third column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _sxz @accessors(property=sxz);
	
	/**
	 * The value in the first row and forth column of the Matrix object,
	 * which affects the positioning along the x axis of a 3d object.
	 */
	float _tx @accessors(property=tx);
	
	/**
	 * The value in the second row and first column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _syx @accessors(property=syx);
	
	/**
	 * The value in the second row and second column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _syy @accessors(property=syy);
	
	/**
	 * The value in the second row and third column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _syz @accessors(property=syz);
	
	/**
	 * The value in the second row and fourth column of the Matrix object,
	 * which affects the positioning along the y axis of a 3d object.
	 */
	float _ty @accessors(property=ty);
	
	/**
	 * The value in the third row and first column of the Matrix object,
	 * which affects the rotation and scaling of a 3d object.
	 */
	float _szx @accessors(property=szx);
	
	/**
	 * The value in the third row and second column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _szy @accessors(property=szy);
	
	/**
	 * The value in the third row and third column of the Matrix object,
	 * which affect the rotation and scaling of a 3d object.
	 */
	float _szz @accessors(property=szz);
	
	/**
	 * The value in the third row and fourth column of the Matrix object,
	 * which affects the positioning along the z axis of a 3d object.
	 */
	float _tz @accessors(property=tz);
	
	/**
	 * The value in the 4th row and first column of the Matrix object,
	 */
	float _swx @accessors(property=swx);
	
	/**
	 * The value in the 4th row and second column of the Matrix object,
	 */
	float _swy @accessors(property=swy);
	
	/**
	 * The value in the 4th row and third column of the Matrix object,
	 */
	float _swz @accessors(property=swz);
	
	/**
	 * The value in the 4th row and 4th column of the Matrix object,
	 */
	float _tw @accessors(property=tw);
	
}

- (id)init {
	
	self = [super init];
	if (self) {
		_sxx = 1;
		_sxy = 0;
		_sxz = 0;
		_tx  = 0;
		_syx = 0;
		_syy = 1;
		_syz = 0;
		_ty  = 0;
		_szx = 0;
		_szy = 0;
		_szz = 1;
		_tz  = 0;
		_swx = 0;
		_swy = 0;
		_swz = 0;
		_tw  = 1;
	}
	
	return self;
}

- (id)initFromArray:(Array)array {
	 
	self = [super init];
	
	if (self) {
		_sxx = array[0];
		_sxy = array[1];
		_sxz = array[2];
		_tx  = array[3];
		_syx = array[4];
		_syy = array[5];
		_syz = array[6];
		_ty  = array[7];
		_szx = array[8];
		_szy = array[9];
		_szz = array[10];
		_tz  = array[11];
		_swx = array[12];
		_swy = array[13];
		_swz = array[14];
		_tw  = array[15];
	}

	return self;
}

- (id)initFromMatrix3D:(Matrix3D)matrix {
	return [self initFromArray:[matrix getAsArray]];
}


/**
 * Initialises the matrix with a rotation about a given vector.
 * 
 * @param	angle	The angle in radians of the rotation.
 * @param	x		The x value of the rotation vector.
 * @param	y		The y value of the rotation vector.
 * @param	z		The z value of the rotation vector.
 */
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
			_sxx = 1;
			_syx = 0;
			_szx = 0;
			_sxy = 0;
			_syy = 1 - 2 * sinA2;
			_szy = 2 * sinA * cosA;
			_sxz = 0;
			_syz = -2 * sinA * cosA;
			_szz = 1 - 2 * sinA2;
			_swx = _swy = _swz = 0;
			_tx = _ty = _tz = 0;
			_tw = 1;
		} else if (x == 0 && y == 1 && z == 0) {
			_sxx = 1 - 2 * sinA2;
			_syx = 0;
			_szx = -2 * sinA * cosA;
			_sxy = 0;
			_syy = 1;
			_szy = 0;
			_sxz = 2 * sinA * cosA;
			_syz = 0;
			_szz = 1 - 2 * sinA2;
			_swx = _swy = _swz = 0;
			_tx = _ty = _tz = 0;
			_tw = 1;
		} else if (x == 0 && y == 0 && z == 1) {
			_sxx = 1 - 2 * sinA2;
			_syx = 2 * sinA * cosA;
			_szx = 0;
			_sxy = -2 * sinA * cosA;
			_syy = 1 - 2 * sinA2;
			_szy = 0;
			_sxz = 0;
			_syz = 0;
			_szz = 1;
			_swx = _swy = _swz = 0;
			_tx = _ty = _tz = 0;
			_tw = 1;
		} else {
			var x2 = x*x;
			var y2 = y*y;
			var z2 = z*z;
		
			_sxx = 1 - 2 * (y2 + z2) * sinA2;
			_syx = 2 * (x * y * sinA2 + z * sinA * cosA);
			_szx = 2 * (x * z * sinA2 - y * sinA * cosA);
			_sxy = 2 * (y * x * sinA2 - z * sinA * cosA);
			_syy = 1 - 2 * (z2 + x2) * sinA2;
			_szy = 2 * (y * z * sinA2 + x * sinA * cosA);
			_sxz = 2 * (z * x * sinA2 + y * sinA * cosA);
			_syz = 2 * (z * y * sinA2 - x * sinA * cosA);
			_szz = 1 - 2 * (x2 + y2) * sinA2;
			_swx = _swy = _swz = 0;
			_tx = _ty = _tz = 0;
			_tw = 1;
		}
	}
	
	return self;
}

/**
 * Initialises the matrix with a translation.
 * @param	x		The translation along the x axis.
 * @param	y		The translation along the y axis.
 * @param	z		The translation along the z axis..
 */
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


- (void)print {
	CPLog.info("[[" + _m11 + ", " + _m21 + ", " + _m31 + ", " + _m41 + "]");
	CPLog.info(" [" + _m12 + ", " + _m22 + ", " + _m32 + ", " + _m42 + "]");
	CPLog.info(" [" + _m13 + ", " + _m23 + ", " + _m33 + ", " + _m43 + "]");
	CPLog.info(" [" + _m14 + ", " + _m24 + ", " + _m34 + ", " + _m44 + "]]");
}

/**
 * Returns standard row major array
 */
- (Array)getAsArray {
	return [_sxx, _sxy, _sxz, _tx,
	        _syx, _syy, _syz, _ty,
	        _szx, _szy, _szz, _tz,
	        _swx, _swy, _swz, _tw];
}

/**
 * Returns a column major canvas float array, specifically for passing to opengl
 */
- (Array)getAsColumnMajorCanvasFloatArray {
	return new CanvasFloatArray([_sxx, _syx, _szx, _swx,
	                             _sxy, _syy, _szy, _swy,
	                             _sxz, _syz, _szz, _swz,
	                             _tx,  _ty,  _tz,  _tw]);
}


/**
 * Calculate the 4x4 Matrix3D resulting from m1 x m2
 */
- (void)multiply:(Matrix3D)m1 m2:(Matrix3D)m2 {
	
	var m1Array = [m1 getAsArray];
	var m2Array = [m2 getAsArray];
	
	var m111 = m1Array[0];
	var m112 = m1Array[1];
	var m113 = m1Array[2];
	var m114 = m1Array[3];
	var m121 = m1Array[4];
	var m122 = m1Array[5];
	var m123 = m1Array[6];
	var m124 = m1Array[7];
	var m131 = m1Array[8];
	var m132 = m1Array[9];
	var m133 = m1Array[10];
	var m134 = m1Array[11];
	var m141 = m1Array[12];
	var m142 = m1Array[13];
	var m143 = m1Array[14];
	var m144 = m1Array[15];
	
	var m211 = m2Array[0];
	var m212 = m2Array[1];
	var m213 = m2Array[2];
	var m214 = m2Array[3];
	var m221 = m2Array[4];
	var m222 = m2Array[5];
	var m223 = m2Array[6];
	var m224 = m2Array[7];
	var m231 = m2Array[8];
	var m232 = m2Array[9];
	var m233 = m2Array[10];
	var m234 = m2Array[11];
	var m241 = m2Array[12];
	var m242 = m2Array[13];
	var m243 = m2Array[14];
	var m244 = m2Array[15];
	
	
	_sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	_sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	_sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	_tx = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	_syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	_syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	_syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	_ty = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	_szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	_szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	_szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	_tz = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	_swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	_swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	_swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	_tw = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
}


/**
 * Returns the determinant of the matrix
 */
- (float)determinant {
	
	return    (_sxx * _syy - _syx * _sxy) * (_szz * _tw - _swz * _tz) 
			- (_sxx * _szy - _szx * _sxy) * (_syz * _tw - _swz * _ty) 
			+ (_sxx * _swy - _swx * _sxy) * (_syz * _tz - _szz * _ty) 
			+ (_syx * _szy - _szx * _syy) * (_sxz * _tw - _swz * _tx) 
			- (_syx * _swy - _swx * _syy) * (_sxz * _tz - _szz * _tx) 
			+ (_szx * _swy - _swx * _szy) * (_sxz * _ty - _syz * _tx);
}



/**
 * Scales the 3d matrix by the given amount in each dimension
 * 
 * @param	m	The 3d matrix to scale from.
 * @param	x	The scale value along the x axis.
 * @param	y	The scale value along the y axis.
 * @param	z	The scale value along the z axis.
 */
- (void)scale:(Matrix3D)m1 x:(float)x y:(float)y z:(float)z {
	
	var m1Array = [m1 getAsArray];
	var sxx = array[0];
	var sxy = array[1];
	var sxz = array[2];
	var syx = array[4];
	var syy = array[5];
	var syz = array[6];
	var szx = array[8];
	var szy = array[9];
	var szz = array[10];
	var swx = array[12];
	var swy = array[13];
	var swz = array[14];

	
	_sxx = sxx * x;
	_syx = syx * x;
	_szx = szx * x;
	_sxy = sxy * y;
	_syy = syy * y;
	_szy = szy * y;
	_sxz = sxz * z;
	_syz = syz * z;
	_szz = szz * z;
}



/**
* Fills the 3d matrix object with values representing the given translation.
* 
* @param	u		The translation along the x axis.
* @param	v		The translation along the y axis.
* @param	w		The translation along the z axis..
*/
- (void)translationMatrix:(float)u v:(float)v w:(float)w {
	
	_sxx = _syy = _szz = 1;
	_sxy = _sxz = _syz = _syz = _szx = _szy = 0;
	_tx = u;
	_ty = v;
	_tz = w;
}

/**
* Fills the 3d matrix object with values representing the given scaling.
* 
* @param	u		The scale along the x axis.
* @param	v		The scale along the y axis.
* @param	w		The scale along the z axis..
*/
- (void)scaleMatrix:(float)u v:(float)v w:(float)w {
	
	_tx = _sxy = _sxz = 0;
	_syz = _ty = _syz = 0;
	_szx = _szy = _tz = 0;
	_sxx = u;
	_syy = v;
	_szz = w;
}



@end


