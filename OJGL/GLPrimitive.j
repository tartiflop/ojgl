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
	int _normalBufferId;
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

- (void)prepareNormals:(GLContext)glContext  {
	// Create and initialise normal buffer data
	_normalBufferId = [glContext createBufferFromArray:_normals];
}

- (void)rotate:(float)angle x:(float)x y:(float)y z:(float)z {
	_transformation.rotate(angle, x, y, z);
}

- (void)setRotation:(float)angle x:(float)x y:(float)y z:(float)z {
	_transformation.setRotation(angle, x, y, z);
}

- (void)translate:(float)x y:(float)y z:(float)z {
	_transformation.translate(x, y, z);
}

- (void)setTranslation:(float)x y:(float)y z:(float)z {
	_transformation.setTranslation(x, y, z);
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

- (int)getUVBufferId {
	return _uvBufferId;
}

- (int)getVertexBufferId {
	return _vertexBufferId;
}

- (int)getNormalBufferId {
	return _normalBufferId;
}

- (int)getIndicesBufferId {
	return _indicesBufferId;
}

- (GLMaterial)getMaterial {
	return _material;
}

- (Matrix4D)getTransformation {
	return _transformation;
}


@end
