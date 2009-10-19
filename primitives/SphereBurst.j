@import <Foundation/CPObject.j>


@implementation Sphere : CPObject {
	float _radius;
	int _longs;
	int _lats;
	
	Array _geometryData;
	Array _colorData;
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
	_colorData = [];
	_indexData = [];

	for (var latNumber = 0; latNumber <= _lats; ++latNumber) {
		for (var longNumber = 0; longNumber < _longs; ++longNumber) {
			var theta = latNumber * Math.PI / _lats;
			var phi = longNumber * 2 * Math.PI / _longs;
			
			var sinTheta = Math.sin(theta);
			var sinPhi = Math.sin(phi);
			var cosTheta = Math.cos(theta);
			var cosPhi = Math.cos(phi);
			
			var x = cosPhi * sinTheta;
			var y = cosTheta;
			var z = sinPhi * sinTheta;
			
			_geometryData.push(_radius * x + Math.random()-0.5);
			_geometryData.push(_radius * y + Math.random()-0.5);
			_geometryData.push(_radius * z + Math.random()-0.5);
			
			_colorData.push(Math.random());
			_colorData.push(Math.random());
			_colorData.push(Math.random());
			_colorData.push(1.0);
		}
	}

	for (var latNumber = 0; latNumber < _lats; latNumber++) {
		for (var longNumber = 0; longNumber < _longs; longNumber++) {
			
			var first = (latNumber * _longs) + longNumber;
			var second = first + _longs;
			var third = (latNumber * _longs) + ((longNumber + 1) % _longs);
			var fourth = third + _longs;
			
			_indexData.push(first);
			_indexData.push(second);
			_indexData.push(third);

			_indexData.push(second);
			_indexData.push(fourth);
			_indexData.push(third);
		}
	}

	/*
	_geometryData.push(0.0,  0.5,  0);
	_geometryData.push(-0.5, -0.5,  0);
	_geometryData.push(0.5, -0.5,  0 );

	_indexData.push(0, 1, 2);
	*/
}

- (Array)geometryData {
	return _geometryData;
}

- (Array)colorData {
	return _colorData;
}

- (Array)indexData {
	return _indexData;
}

- (int)numberOfElements {
	return _indexData.length;
}


@end