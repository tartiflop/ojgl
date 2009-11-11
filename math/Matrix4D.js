
Matrix4D = function(m) {
	if (typeof m == 'object') {
		if ("length" in m && m.length >= 16) {
			this.load([m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15]]);
			return;
		}
		else if (m instanceof Matrix4D) {
			this.load(m);
			return;
		}
	}
	this.makeIdentity();
}

Matrix4D.prototype.load = function() {
	if (arguments.length == 1 && typeof arguments[0] == 'object') {
		var matrix = arguments[0];
		if ("length" in matrix && matrix.length == 16) {
			this.sxx = matrix[0];
			this.sxy = matrix[1];
			this.sxz = matrix[2];
			this.tx  = matrix[3];

			this.syx = matrix[4];
			this.syy = matrix[5];
			this.syz = matrix[6];
			this.ty  = matrix[7];

			this.szx = matrix[8];
			this.szy = matrix[9];
			this.szz = matrix[10];
			this.tz  = matrix[11];

			this.swx = matrix[12];
			this.swy = matrix[13];
			this.swz = matrix[14];
			this.tw  = matrix[15];
			return;
		}
			
		if (arguments[0] instanceof Matrix4D) {
		
			this.sxx = matrix.sxx;
			this.sxy = matrix.sxy;
			this.sxz = matrix.sxz;
			this.tx  = matrix.tx;

			this.syx = matrix.syx;
			this.syy = matrix.syy;
			this.syz = matrix.syz;
			this.ty  = matrix.ty;

			this.szx = matrix.szx;
			this.szy = matrix.szy;
			this.szz = matrix.szz;
			this.tz  = matrix.tz;

			this.swx = matrix.swx;
			this.swy = matrix.swy;
			this.swz = matrix.swz;
			this.tw  = matrix.tw;
			return;
		}
	}
	
	this.makeIdentity();
}


Matrix4D.prototype.toString = function() {
	return  "\n[" + this.sxx + ", " + this.sxy + ", " + this.sxz + ", " + this.tx + "]\n" +
			"[" + this.syx + ", " + this.syy + ", " + this.syz + ", " + this.ty + "]\n" +
			"[" + this.szx + ", " + this.szy + ", " + this.szz + ", " + this.tz + "]\n" +
			"[" + this.swx + ", " + this.swy + ", " + this.swz + ", " + this.tw + "]"
}


/**
 * Returns standard row major array
 */
Matrix4D.prototype.getAsArray = function() {
	return [this.sxx, this.sxy, this.sxz, this.tx, 
			  this.syx, this.syy, this.syz, this.ty, 
			  this.szx, this.szy, this.szz, this.tz, 
			  this.swx, this.swy, this.swz, this.tw];
}

/**
 * Returns a column major canvas float array, specifically for passing to opengl
 */
 Matrix4D.prototype.getAsColumnMajorCanvasFloatArray = function() {
	return new CanvasFloatArray([this.sxx, this.syx, this.szx, this.swx,
										  this.sxy, this.syy, this.szy, this.swy,
										  this.sxz, this.syz, this.szz, this.swz,
										  this.tx,  this.ty,  this.tz,  this.tw]);
}

/**
 * Returns a column major canvas float array, specifically for passing to opengl
 */
Matrix4D.prototype.getAs3x3ColumnMajorCanvasFloatArray = function() {
	return new CanvasFloatArray([this.sxx, this.syx, this.szx,
								  this.sxy, this.syy, this.szy,
								  this.sxz, this.syz, this.szz]);
}



Matrix4D.prototype.makeIdentity = function() {
	this.sxx = this.syy = this.szz = this.tw = 1;
	this.sxy = this.sxz = this.tx  = 0;
	this.syx = this.syz = this.ty  = 0;
	this.szx = this.szy = this.tz  = 0;
	this.swx = this.swy = this.swz = 0;
}

/**
* Returns the determinant of the matrix
*/
Matrix4D.prototype.determinant = function() {
	
	return	(this.sxx * this.syy - this.syx * this.sxy) * (this.szz * this.tw - this.swz * this.tz) 
			- (this.sxx * this.szy - this.szx * this.sxy) * (this.syz * this.tw - this.swz * this.ty) 
			+ (this.sxx * this.swy - this.swx * this.sxy) * (this.syz * this.tz - this.szz * this.ty) 
			+ (this.syx * this.szy - this.szx * this.syy) * (this.sxz * this.tw - this.swz * this.tx) 
			- (this.syx * this.swy - this.swx * this.syy) * (this.sxz * this.tz - this.szz * this.tx) 
			+ (this.szx * this.swy - this.swx * this.szy) * (this.sxz * this.ty - this.syz * this.tx);
}

Matrix4D.prototype.determinant3x3 = function() {
	
	return	(this.sxx * this.syy - this.syx * this.sxy) * this.szz 
			- (this.sxx * this.szy - this.szx * this.sxy) * this.syz 
			+ (this.syx * this.szy - this.szx * this.syy) * this.sxz 
}


Matrix4D.prototype.invert = function() {
	// If the determinant is zero then no inverse exists
	var det = this.determinant();

	if (Math.abs(det) < 1e-8) {
		CPLog.error("Matrix4D: matrix invert request fails")
		return;
	}
	
	var invDet = 1 / det;

	var m11 = this.sxx;
	var m12 = this.sxy;
	var m13 = this.sxz;
	var m14 = this.tx;
	var m21 = this.syx;
	var m22 = this.syy;
	var m23 = this.syz;
	var m24 = this.ty;
	var m31 = this.szx;
	var m32 = this.szy;
	var m33 = this.szz;
	var m34 = this.tz; 
	var m41 = this.swx;
	var m42 = this.swy;
	var m43 = this.swz;
	var m44 = this.tw;
	
	this.sxx =  invDet * (m22 * (m33 * m44 - m43 * m34) - m32 * (m23 * m44 - m43 * m24) + m42 * (m23 * m34 - m33 * m24));
	this.sxy = -invDet * (m12 * (m33 * m44 - m43 * m34) - m32 * (m13 * m44 - m43 * m14) + m42 * (m13 * m34 - m33 * m14));
	this.sxz =  invDet * (m12 * (m23 * m44 - m43 * m24) - m22 * (m13 * m44 - m43 * m14) + m42 * (m13 * m24 - m23 * m14));
	this.tx  = -invDet * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));

	this.syx = -invDet * (m21 * (m33 * m44 - m43 * m34) - m31 * (m23 * m44 - m43 * m24) + m41 * (m23 * m34 - m33 * m24));
	this.syy =  invDet * (m11 * (m33 * m44 - m43 * m34) - m31 * (m13 * m44 - m43 * m14) + m41 * (m13 * m34 - m33 * m14));
	this.syz = -invDet * (m11 * (m23 * m44 - m43 * m24) - m21 * (m13 * m44 - m43 * m14) + m41 * (m13 * m24 - m23 * m14));
	this.ty  =  invDet * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));

	this.szx =  invDet * (m21 * (m32 * m44 - m42 * m34) - m31 * (m22 * m44 - m42 * m24) + m41 * (m22 * m34 - m32 * m24));
	this.szy = -invDet * (m11 * (m32 * m44 - m42 * m34) - m31 * (m12 * m44 - m42 * m14) + m41 * (m12 * m34 - m32 * m14));
	this.szz =  invDet * (m11 * (m22 * m44 - m42 * m24) - m21 * (m12 * m44 - m42 * m14) + m41 * (m12 * m24 - m22 * m14));
	this.tz  = -invDet * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));

	this.swx = -invDet * (m21 * (m32 * m43 - m42 * m33) - m31 * (m22 * m43 - m42 * m23) + m41 * (m22 * m33 - m32 * m23));
	this.swy =  invDet * (m11 * (m32 * m43 - m42 * m33) - m31 * (m12 * m43 - m42 * m13) + m41 * (m12 * m33 - m32 * m13));
	this.swz = -invDet * (m11 * (m22 * m43 - m42 * m23) - m21 * (m12 * m43 - m42 * m13) + m41 * (m12 * m23 - m22 * m13));
	this.tw  =  invDet * (m11 * (m22 * m33 - m32 * m23) - m21 * (m12 * m33 - m32 * m13) + m31 * (m12 * m23 - m22 * m13));	
	
}

Matrix4D.prototype.invert3x3 = function() {
	// If the determinant is zero then no inverse exists
	var det = this.determinant3x3();

	if (Math.abs(det) < 1e-8) {
		CPLog.error("Matrix4D: matrix invert3x3 request fails")
		return;
	}
	
	var invDet = 1 / det;

	var m11 = this.sxx;
	var m12 = this.sxy;
	var m13 = this.sxz;
	var m21 = this.syx;
	var m22 = this.syy;
	var m23 = this.syz;
	var m31 = this.szx;
	var m32 = this.szy;
	var m33 = this.szz;

	this.sxx =  invDet * (m22 * m33 - m32 * m23),
	this.sxy = -invDet * (m12 * m33 - m32 * m13),
	this.sxz =  invDet * (m12 * m23 - m22 * m13),
	this.syx = -invDet * (m21 * m33 - m31 * m23),
	this.syy =  invDet * (m11 * m33 - m31 * m13),
	this.syz = -invDet * (m11 * m23 - m21 * m13),
	this.szx =  invDet * (m21 * m32 - m31 * m22),
	this.szy = -invDet * (m11 * m32 - m31 * m12),
	this.szz =  invDet * (m11 * m22 - m21 * m12),


	this.swx = this.swy = this.swz = 0;
	this.tx = this.ty = this.tz = 0;
	this.tw = 1;
}


Matrix4D.prototype.rotate = function(angle, x, y, z) {
	
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
	
	 var matrix = new Matrix4D();

	// optimize case where axis is along major axis
	if (x == 1 && y == 0 && z == 0) {
		matrix.sxx = 1;
		matrix.syx = 0;
		matrix.szx = 0;
		matrix.sxy = 0;
		matrix.syy = 1 - 2 * sinA2;
		matrix.szy = 2 * sinA * cosA;
		matrix.sxz = 0;
		matrix.syz = -2 * sinA * cosA;
		matrix.szz = 1 - 2 * sinA2;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	} else if (x == 0 && y == 1 && z == 0) {
		matrix.sxx = 1 - 2 * sinA2;
		matrix.syx = 0;
		matrix.szx = -2 * sinA * cosA;
		matrix.sxy = 0;
		matrix.syy = 1;
		matrix.szy = 0;
		matrix.sxz = 2 * sinA * cosA;
		matrix.syz = 0;
		matrix.szz = 1 - 2 * sinA2;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	} else if (x == 0 && y == 0 && z == 1) {
		matrix.sxx = 1 - 2 * sinA2;
		matrix.syx = 2 * sinA * cosA;
		matrix.szx = 0;
		matrix.sxy = -2 * sinA * cosA;
		matrix.syy = 1 - 2 * sinA2;
		matrix.szy = 0;
		matrix.sxz = 0;
		matrix.syz = 0;
		matrix.szz = 1;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	} else {
		var x2 = x*x;
		var y2 = y*y;
		var z2 = z*z;
	
		matrix.sxx = 1 - 2 * (y2 + z2) * sinA2;
		matrix.syx = 2 * (x * y * sinA2 + z * sinA * cosA);
		matrix.szx = 2 * (x * z * sinA2 - y * sinA * cosA);
		matrix.sxy = 2 * (y * x * sinA2 - z * sinA * cosA);
		matrix.syy = 1 - 2 * (z2 + x2) * sinA2;
		matrix.szy = 2 * (y * z * sinA2 + x * sinA * cosA);
		matrix.sxz = 2 * (z * x * sinA2 + y * sinA * cosA);
		matrix.syz = 2 * (z * y * sinA2 - x * sinA * cosA);
		matrix.szz = 1 - 2 * (x2 + y2) * sinA2;
		matrix.swx = matrix.swy = matrix.swz = 0;
		matrix.tx = matrix.ty = matrix.tz = 0;
		matrix.tw = 1;
	}	
	
	this._multiplyOnLeft(matrix);
}

Matrix4D.prototype.translate = function(x, y, z) {
	if (x == undefined) {
		x = 0;
	}
	if (y == undefined) {
		y = 0;
	}
	if (z == undefined) {
		z = 0;
	}
	 
	 var matrix = new Matrix4D();
	 matrix.tx = x;
	 matrix.ty = y;
	 matrix.tz = z;

	 this._multiplyOnLeft(matrix);
}

Matrix4D.prototype.scale = function(x, y, z) {
	
	this.sxx *= x;
	this.sxy *= x;
	this.sxz *= x;
	this.tx  *= x;
	this.syx *= y;
	this.syy *= y;
	this.syz *= y;
	this.ty  *= y;
	this.szx *= z;
	this.szy *= z;
	this.szz *= z;
	this.tz  *= z;
}

Matrix4D.prototype.transpose = function() {

	var tmp = this.sxy;
    this.sxy = this.syx;
    this.syx = tmp;
    
    tmp = this.sxz;
    this.sxz = this.szx;
    this.szx = tmp;
    
    tmp = this.tx;
    this.tx = this.swx;
    this.swx = tmp;
    
    tmp = this.syz;
    this.syz = this.szy;
    this.szy = tmp;
    
    tmp = this.ty;
    this.ty = this.swy;
    this.swy = tmp;
    
    tmp = this.tz;
    this.tz = this.swz;
    this.swz = tmp;
}

Matrix4D.prototype.setTranslation = function(x, y, z) {

	this.tx = x;
	this.ty = y;
	this.tz = z;
}

Matrix4D.prototype.setRotation = function(angle, x, y, z) {

	var matrix = new Matrix4D();
	matrix.rotate(angle, x, y, z);
	
	this.sxx = matrix.sxx;
	this.sxy = matrix.sxy;
	this.sxz = matrix.sxz;
	this.syx = matrix.syx;
	this.syy = matrix.syy;
	this.syz = matrix.syz;
	this.szx = matrix.szx;
	this.szy = matrix.szy;
	this.szz = matrix.szz;
	
}


/**
 * Result is: this = this x matrix
 */
Matrix4D.prototype.multiply = function(matrix) {
	
	var m111 = this.sxx;
	var m112 = this.sxy;
	var m113 = this.sxz;
	var m114 = this.tx;
	var m121 = this.syx;
	var m122 = this.syy;
	var m123 = this.syz;
	var m124 = this.ty;
	var m131 = this.szx;
	var m132 = this.szy;
	var m133 = this.szz;
	var m134 = this.tz;
	var m141 = this.swx;
	var m142 = this.swy;
	var m143 = this.swz;
	var m144 = this.tw;
	
	var m211 = matrix.sxx;
	var m212 = matrix.sxy;
	var m213 = matrix.sxz;
	var m214 = matrix.tx;
	var m221 = matrix.syx;
	var m222 = matrix.syy;
	var m223 = matrix.syz;
	var m224 = matrix.ty;
	var m231 = matrix.szx;
	var m232 = matrix.szy;
	var m233 = matrix.szz;
	var m234 = matrix.tz;
	var m241 = matrix.swx;
	var m242 = matrix.swy;
	var m243 = matrix.swz;
	var m244 = matrix.tw;
	
	this.sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	this.sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	this.sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	this.tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	this.syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	this.syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	this.syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	this.ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	this.szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	this.szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	this.szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	this.tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	this.swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	this.swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	this.swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	this.tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
}

Matrix4D.prototype.multVec = function(array) {
	
	if (array.length != 4) {
		return null;
	}
	
	var ax = array[0];
	var ay = array[1];
	var az = array[2];
	var aw = array[3];
	
	var vx = this.sxx * ax + this.sxy * ay + this.sxz * az + this.tx * aw;
	var vy = this.syx * ax + this.syy * ay + this.syz * az + this.ty * aw;
	var vz = this.szx * ax + this.szy * ay + this.szz * az + this.tz * aw;
	var vw = this.swx * ax + this.swy * ay + this.swz * az + this.tw * aw;
	
	return [vx, vy, vz, vw];
}


/**
* Result is: this = matrix x this
*/
Matrix4D.prototype._multiplyOnLeft = function(matrix) {
	
	var m111 = matrix.sxx;
	var m112 = matrix.sxy;
	var m113 = matrix.sxz;
	var m114 = matrix.tx;
	var m121 = matrix.syx;
	var m122 = matrix.syy;
	var m123 = matrix.syz;
	var m124 = matrix.ty;
	var m131 = matrix.szx;
	var m132 = matrix.szy;
	var m133 = matrix.szz;
	var m134 = matrix.tz;
	var m141 = matrix.swx;
	var m142 = matrix.swy;
	var m143 = matrix.swz;
	var m144 = matrix.tw;

	var m211 = this.sxx;
	var m212 = this.sxy;
	var m213 = this.sxz;
	var m214 = this.tx;
	var m221 = this.syx;
	var m222 = this.syy;
	var m223 = this.syz;
	var m224 = this.ty;
	var m231 = this.szx;
	var m232 = this.szy;
	var m233 = this.szz;
	var m234 = this.tz;
	var m241 = this.swx;
	var m242 = this.swy;
	var m243 = this.swz;
	var m244 = this.tw;
	
	this.sxx = m111 * m211 + m112 * m221 + m113 * m231 + m114 * m241;
	this.sxy = m111 * m212 + m112 * m222 + m113 * m232 + m114 * m242;
	this.sxz = m111 * m213 + m112 * m223 + m113 * m233 + m114 * m243;
	this.tx  = m111 * m214 + m112 * m224 + m113 * m234 + m114 * m244;
	this.syx = m121 * m211 + m122 * m221 + m123 * m231 + m124 * m241;
	this.syy = m121 * m212 + m122 * m222 + m123 * m232 + m124 * m242;
	this.syz = m121 * m213 + m122 * m223 + m123 * m233 + m124 * m243;
	this.ty  = m121 * m214 + m122 * m224 + m123 * m234 + m124 * m244;
	this.szx = m131 * m211 + m132 * m221 + m133 * m231 + m134 * m241;
	this.szy = m131 * m212 + m132 * m222 + m133 * m232 + m134 * m242;
	this.szz = m131 * m213 + m132 * m223 + m133 * m233 + m134 * m243;
	this.tz  = m131 * m214 + m132 * m224 + m133 * m234 + m134 * m244;
	this.swx = m141 * m211 + m142 * m221 + m143 * m231 + m144 * m241;
	this.swy = m141 * m212 + m142 * m222 + m143 * m232 + m144 * m242;
	this.swz = m141 * m213 + m142 * m223 + m143 * m233 + m144 * m243;
	this.tw  = m141 * m214 + m142 * m224 + m143 * m234 + m144 * m244;
}

Matrix4D.InverseMatrix = function (inMatrix) {
	var matrix = new Matrix4D(inMatrix);
	matrix.invert();
	
	return matrix;
}

Matrix4D.Inverse3x3Matrix = function (inMatrix) {
	var matrix = new Matrix4D(inMatrix);
	matrix.invert3x3();
	
	return matrix;
}

Matrix4D.RotationMatrix = function (angle, x, y, z) {
	var matrix = new Matrix4D();
	matrix.rotate(angle, x, y, z);
	
	return matrix;
}

Matrix4D.TranslationMatrix = function (x, y, z) {
	var matrix = new Matrix4D();
	matrix.translate(x, y, z);
	
	return matrix;
}

Matrix4D.ScaleMatrix = function (x, y, z) {
	var matrix = new Matrix4D();
	matrix.scale(x, y, z);
	
	return matrix;
}

Matrix4D.TransposeMatrix = function (inMatrix) {
	var matrix = new Matrix4D(inMatrix);
	matrix.transpose();
	
	return matrix;
}
