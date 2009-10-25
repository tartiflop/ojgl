@import <Foundation/CPObject.j>
@import "GLContext.j"
@import "GLRenderer.j"
@import "GLMaterial.j"

@implementation GLPrimitive : CPObject {
	Array _vertices;
	Array _normals;
	Array _uvs;
	Array _indices;
	
	int _vertexBufferId;
	int _uvBufferId;
	int _indicesBufferId;

	GLMaterial _material;
	Matrix4D _transformation;
}

- (id)init:(GLMaterial)material {
	self = [super init];
	
	if (self) {
		_material = material;
		[_material setPrimitive:self];
		
		_transformation = new Matrix4D();
	}
	
	return self;
}

- (void)buildPrimitive {
	_vertices = [];
	_normals = [];
	_uvs = [];
	_indices = [];

}

- (void)prepareGL:(GLContext)glContext {
	
	// Initialise the material
	[_material prepareGL:glContext];
	
	// Create and initialise buffer data
	_vertexBufferId = [glContext createBufferFromArray:_vertices];
	_indicesBufferId = [glContext createBufferFromElementArray:_indices];
}

- (void)prepareUVs:(GLContext)glContext  {
	// Create and initialise UV buffer data
	_uvBufferId = [glContext createBufferFromArray:_uvs];
}

- (void)render:(GLRenderer)renderer {
	
	// Prepare the material to be rendered
	[_material prepareRenderer:renderer];
	
	// Set model view matrix
	[renderer setModelViewMatrix:_transformation];

	// Send the vertex data to the renderer
	[renderer setVertexBufferData:_vertexBufferId];
	
	// Bind element index buffer
	[renderer setElementBufferData:_indicesBufferId];

	// render elements
	[renderer drawElements:_indices.length];
}

- (void)getUVBufferId {
	return _uvBufferId;
}

/**
 * Rotates by given angle about given vector
 */
- (void)rotate:(float)angle x:(float)x y:(float)y z:(float)z {
	_transformation.rotate(angle, x, y, z);
}

/**
 * Translates along given vector
 */
- (void)translate:(float)x y:(float)y z:(float)z {
	_transformation.translate(x, y, z);
}

/**
 * Translates to given position
 */
- (void)translateTo:(float)x y:(float)y z:(float)z {
	_transformation.translateTo(x, y, z);
}

- (void)resetTransformation {
	_transformation.makeIdentity();
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

- (int)numberOfVertices {
	return _vertices.length;
}



@end
