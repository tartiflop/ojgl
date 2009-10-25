@import <Foundation/CPObject.j>

@implementation GLU : CPObject {

}

- (id)init {
	self = [super init];
	
	if (self) {
	}
	
	return self;
}

+ (Matrix4D)lookAt:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz {
	
	// remember: z out of screen
	var zx = eyex - centerx;
	var zy = eyey - centery;
	var zz = eyez - centerz;
	
	// normalise z
	var zlen = Math.sqrt(zx * zx + zy * zy + zz * zz);
	zx /= zlen;
	zy /= zlen;
	zz /= zlen;
	
	// Calculate cross product of up and z to get x 
	// (x coming out of plane containing up and z: up not necessarily perpendicular to z)
	var xx =  upy * zz - upz * zy;
	var xy = -upx * zz + upz * zx;
	var xz =  upx * zy - upy * zx;
	
	// up not necessarily a unit vector so normalise x
	var xlen = Math.sqrt(xx * xx + xy * xy + xz * xz);
	xx /= xlen;
	xy /= xlen;
	xz /= xlen;
	
	// calculate y: cross product of z and x (x and z unit vector so no need to normalise after)
	var yx =  zy * xz - zz * xy;
	var yy = -zx * xz + zz * xx;
	var yz =  zx * xy - zy * xx;

	// Create rotation matrix from new coorinate system
	var lookatMatrix = new Matrix4D([xx, xy, xz, 0, yx, yy, yz, 0, zx, zy, zz, 0, 0, 0, 0, 1]);
	
	// create translation matrix
	var translationMatrix = new Matrix4D([1, 0, 0, -eyex, 0, 1, 0, -eyey, 0, 0, 1, -eyez, 0, 0, 0, 1]);
	
	// calculate final lookat (projection) matrix from combination of both rotation and translation
	lookatMatrix.multiply(translationMatrix);
	
	return lookatMatrix;
}

+ (Matrix4D)perspective:(float)fovy aspect:(float)aspect near:(float)near far:(float)far {

	var top = Math.tan(fovy * Math.PI / 360) * near;
	var bottom = -top;
	var left = aspect * bottom;
	var right = aspect * top;

	var A = (right + left) / (right - left);
	var B = (top + bottom) / (top - bottom);
	var C = -(far + near) / (far - near);
	var D = -(2 * far * near) / (far - near);
	
	var matrix = new Matrix4D();
	matrix.sxx = (2 * near) / (right - left);
	matrix.syx = 0;
	matrix.szx = 0;
	matrix.swx = 0;
	
	matrix.sxy = 0;
	matrix.syy = 2 * near / (top - bottom);
	matrix.szy = 0;
	matrix.swy = 0;
	
	matrix.sxz = A;
	matrix.syz = B;
	matrix.szz = C;
	matrix.swz = -1;
	
	matrix.tx = 0;
	matrix.ty = 0;
	matrix.tz = D;
	matrix.tw = 0;
	
	return matrix;
}

+ (Matrix4D)ortho:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far {
	var tx = (left + right) / (right - left);
	var ty = (top + bottom) / (top - bottom);
	var tz = (far + near) / (far - near);
	
	var matrix = new Matrix4D();
	matrix.sxx = 2 / (right - left);
	matrix.sxy = 0;
	matrix.sxz = 0;
	matrix.tx  = tx;
	matrix.syx = 0;
	matrix.syy = 2 / (top - bottom);
	matrix.syz = 0;
	matrix.ty  = ty;
	matrix.szx = 0;
	matrix.szy = 0;
	matrix.szz = -2 / (far - near);
	matrix.tz  = -tz;
	matrix.swx = 0;
	matrix.swy = 0;
	matrix.swz = 0;
	matrix.tw  = 1;
	
	return matrix;
}

@end
