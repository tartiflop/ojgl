@import <Foundation/CPObject.j>
@import "GLContext.j"
@import "GLRenderer.j"
@import "../math/Matrix3D.J"

@implementation GLPrimitive : CPObject {
	Array _vertices;
	Array _normals;
	Array _uvs;
	Array _indices;
	
	int _vertexBufferId;
	int _uvBufferId;
	int _indicesBufferId;

	Matrix3D _transformation;
}

- (id)init {
	self = [super init];
	
	if (self) {
	}
	
	return self;
}

- (void)buildPrimitive {
	_vertices = [];
	_normals = [];
	_uvs = [];
	_indices = [];

}

- (void)initialiseBuffers:(GLContext)glContext {
	// Create and initialise buffer data
	_vertexBufferId = [glContext createBufferFromArray:_vertices];
	_uvBufferId = [glContext createBufferFromArray:_uvs];
	_indicesBufferId = [glContext createBufferFromElementArray:_indices];

}

- (void)render:(GLRenderer)renderer {
	// Set model view matrix
	[renderer setModelViewMatrix:_transformation];

	// Send the data to the renderer
	[renderer setVertexBufferData:_vertexBufferId];
	[renderer setTexCoordBufferData:_uvBufferId];
	
	// Bind element index buffer
	[renderer setElementBufferData:_indicesBufferId];

	// render elements
	[renderer drawElements:_indices.length];
}

- (void)setRotation:(float)angle {
	_transformation = [[Matrix3D alloc] initWithRotation:angle x:0 y:1 z:0];
}

- (Array)vertices {
	return _vertices;
}

- (Array)normals {
	return _normals;
}

- (Array)uvs {
	return _uvs;
}

- (Array)indices {
	return _indices;
}

- (int)numberOfElements {
	return _indices.length;
}



@end
