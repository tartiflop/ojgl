@import "../OJGL/GLPrimitive.j"


@implementation SphereBurst : GLPrimitive {
	float _radius;
	int _longs;
	int _lats;
}

- (id)init:(GLMaterial)material {
	return [self initWithGeometry:material radius:0.5 longs:6 lats:6];
}


- (id)initWithGeometry:(GLMaterial)material radius:(float)radius longs:(int)longs lats:(int)lats {
	self = [super init:material];
	
	if (self) {
		_radius = radius;
		_longs = longs;
		_lats = lats;
		
		[self buildPrimitive];
	}
	
	return self;
}

- (void)buildPrimitive {
	[super buildPrimitive];

	
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
		
			_vertices.push(_radius * x + Math.random());
			_vertices.push(_radius * y + Math.random());
			_vertices.push(_radius * z);
			
			_normals.push(x);
			_normals.push(y);
			_normals.push(z);
			
			_uvs.push(u);
			_uvs.push(v);
		}
	}

	for (var latNumber = 0; latNumber < _lats; latNumber++) {
		for (var longNumber = 0; longNumber < _longs; longNumber++) {
			
			var first = (latNumber * (_longs + 1)) + longNumber;
			var second = first + (_longs + 1);
			var third = first + 1;
			var fourth = second + 1;
			
			_indices.push(first);
			_indices.push(third);
			_indices.push(second);

			_indices.push(second);
			_indices.push(third);
			_indices.push(fourth);
		}
	}

}

@end
