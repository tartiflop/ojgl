@import <Foundation/CPObject.j>


@implementation TriangleTest : CPObject {
	
	Array _geometryData;
	Array _colorData;
	Array _indexData;
}

- (id)init {
	self = [super init];
	if (self) {
		[self buildPrimitive];
	}
	return self;
}

- (void)buildPrimitive {

	_geometryData = [];
	_colorData = [];
	_indexData = [];

	_geometryData.push(0.0,  0.5,  0.0);
	_geometryData.push(-0.5, -0.5, 0.0);
	_geometryData.push(0.5, -0.5,  0.0);

	_geometryData.push(0.0,  0.0,  0.5);
	_geometryData.push(-0.5, 0.0, -0.5);
	_geometryData.push(0.5,  0.0, -0.5);

	_geometryData.push(0.0,  0.5,  0.0);
	_geometryData.push(0.0, -0.5, -0.5);
	_geometryData.push(0.0, -0.5,  0.5);


	_colorData.push(1.0, 0.0, 0.0, 1.0);
	_colorData.push(1.0, 0.0, 0.0, 1.0);
	_colorData.push(1.0, 0.0, 0.0, 1.0);
	
	_colorData.push(0.0, 1.0, 0.0, 1.0);
	_colorData.push(0.0, 1.0, 0.0, 1.0);
	_colorData.push(0.0, 1.0, 0.0, 1.0);
	
	_colorData.push(0.0, 0.0, 1.0, 1.0);
	_colorData.push(0.0, 0.0, 1.0, 1.0);
	_colorData.push(0.0, 0.0, 1.0, 1.0);

	_indexData.push(0, 1, 2);
	_indexData.push(3, 4, 5);
	_indexData.push(6, 7, 8);
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
