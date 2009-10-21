@import <Foundation/CPObject.j>
@import "../math/Matrix3D.j"

@implementation GLU : CPObject {

}

- (id)init {
	self = [super init];
	
	if (self) {
	}
	
	return self;
}

+ (Matrix3D)lookAt:(float)eyex eyey:(float)eyey eyez:(float)eyez centerx:(float)centerx centery:(float)centery centerz:(float)centerz upx:(float)upx upy:(float)upy upz:(float)upz {
	
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
	var rotationMatrix = [[Matrix3D alloc] initFromArray:[xx, xy, xz, 0, yx, yy, yz, 0, zx, zy, zz, 0, 0, 0, 0, 1]];
	
	// create translation matrix
	var translationMatrix = [[Matrix3D alloc] initFromArray:[1, 0, 0, -eyex, 0, 1, 0, -eyey, 0, 0, 1, -eyez, 0, 0, 0, 1]];
	
	// calculate lookat (projection) matrix from combination of both
	var lookatMatrix = [[Matrix3D alloc] init];
	[lookatMatrix multiply:rotationMatrix m2:translationMatrix];
	
	return lookatMatrix;
}

+ (Matrix3D)perspective:(float)fovy aspect:(float)aspect near:(float)near far:(float)far {

	var top = Math.tan(fovy * Math.PI / 360) * near;
	var bottom = -top;
	var left = aspect * bottom;
	var right = aspect * top;

	var A = (right + left) / (right - left);
	var B = (top + bottom) / (top - bottom);
	var C = -(far + near) / (far - near);
	var D = -(2 * far * near) / (far - near);
	
	var sxx = (2 * near) / (right - left);
	var syx = 0;
	var szx = 0;
	var swx = 0;
	
	var sxy = 0;
	var syy = 2 * near / (top - bottom);
	var szy = 0;
	var swy = 0;
	
	var sxz = A;
	var syz = B;
	var szz = C;
	var swz = -1;
	
	var tx = 0;
	var ty = 0;
	var tz = D;
	var tw = 0;
	
	return [[Matrix3D alloc] initFromArray:[sxx, sxy, sxz, tx, syx, syy, syz, ty, szx, szy, szz, tz, swx, swy, swz, tw]];
}


@end
