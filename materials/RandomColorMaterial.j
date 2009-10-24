@import "../OJGL/GLMaterial.j"

@implementation RandomColorMaterial : GLMaterial {

	Array _colorData;
	int _colorBufferId;
}

- (id)init {
	self = [super init];
	
	if (self) {

	}
	
	return self;
}

- (void)prepareGL:(GLContext)glContext {

	_colorData = [];
	var nbVertices = [_primitive numberOfVertices];
	
	for (var i = 0; i < nbVertices; i++) {
		_colorData.push(Math.random());
		_colorData.push(Math.random());
		_colorData.push(Math.random());
		_colorData.push(1.0);
	}
	
	_colorBufferId = [glContext createBufferFromArray:_colorData];
}

- (void)prepareRenderer:(GLRenderer)renderer {
	[renderer setColorBufferData:_colorBufferId];
}


@end
