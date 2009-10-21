@import <Foundation/CPObject.j>


@implementation TextureSphere : CPObject {
	float _radius;
	int _longs;
	int _lats;
	
	Array _geometryData;
	Array _normalData;
	Array _texCoordData;
	Array _indexData;
}

- (id)init {
	return [self initWithGeometry:0.5 longs:6 lats:6];
}


- (id)initWithGeometry:(float)radius longs:(int)longs lats:(int)lats {
	self = [super init];
	
	if (self) {
		_radius = radius;
		_longs = longs;
		_lats = lats;
		
		[self buildPrimitive];
	}
	
	return self;
}

- (void)buildPrimitive {

	_geometryData = [];
	_normalData = [];
	_texCoordData = [];
	_indexData = [];

	
	for (var latNumber = 0; latNumber <= _lats; ++latNumber) {
		for (var longNumber = 0; longNumber <= _longs; ++longNumber) {
			var theta = latNumber * Math.PI / _lats;
			var phi = longNumber * 2 * Math.PI / _longs;
			
			var sinTheta = Math.sin(theta);
			var sinPhi = Math.sin(phi);
			var cosTheta = Math.cos(theta);
			var cosPhi = Math.cos(phi);
			
			var x = cosPhi * sinTheta;
			var y = cosTheta;
			var z = sinPhi * sinTheta;
			var u = 1 - (longNumber / _longs);
			var v = latNumber / _lats;
		
			_geometryData.push(_radius * x);
			_geometryData.push(_radius * y);
			_geometryData.push(_radius * z);
			
			_normalData.push(x);
			_normalData.push(y);
			_normalData.push(z);
			
			_texCoordData.push(u);
			_texCoordData.push(v);
		}
	}

	for (var latNumber = 0; latNumber < _lats; latNumber++) {
		for (var longNumber = 0; longNumber < _longs; longNumber++) {
			
			var first = (latNumber * (_longs + 1)) + longNumber;
			var second = first + (_longs + 1);
			var third = first + 1;
			var fourth = second + 1;
			
			_indexData.push(first);
			_indexData.push(third);
			_indexData.push(second);

			_indexData.push(second);
			_indexData.push(third);
			_indexData.push(fourth);
		}
	}

}

- (Array)geometryData {
	return _geometryData;
}

- (Array)normalData {
	return _normalData;
}

- (Array)texCoordData {
	return _texCoordData;
}

- (Array)indexData {
	return _indexData;
}

- (int)numberOfElements {
	return _indexData.length;
}


@end
