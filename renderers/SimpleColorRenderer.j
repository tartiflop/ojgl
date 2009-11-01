@import "../OJGL/GLRenderer.j"

@implementation SimpleColorRenderer : GLRenderer {
	int _vertexAttributeLocation;
	int _colorAttributeLocation;
	int _mvMatrixUniformLocation;
	int _perspectiveUniformLocation;
    Matrix4D _viewMatrix;
    Matrix4D _modelMatrix;
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/vertexShader.glsl" fragmentShaderFile:@"Resources/fragmentShader.glsl"];
	return self;
}


- (void)onShadersLoaded {
	
	// Add shaders to program and link
	[_glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[_glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[_glProgram linkProgram];

	// Get attribute locations
	_vertexAttributeLocation = [_glProgram getAttributeLocation:"aVertex"];
	_colorAttributeLocation = [_glProgram getAttributeLocation:"aColor"];
	_mvMatrixUniformLocation = [_glProgram getUniformLocation:"mvMatrix"];
	_perspectiveUniformLocation = [_glProgram getUniformLocation:"pMatrix"];

	_modelMatrix = new Matrix4D(); _viewMatrix = new Matrix4D();

	// Callback
	[super callback]
}


- (void)setProjectionMatrix:(Matrix4D)projectionMatrix {
	// Set the projection matrix
	[_glContext setUniformMatrix:_perspectiveUniformLocation matrix:projectionMatrix];

}

- (void)setViewMatrix:(Matrix4D)viewMatrix {
    _viewMatrix = viewMatrix;
    var mvMatrix = _viewMatrix; mvMatrix.multiply(_modelMatrix);
	[_glContext setUniformMatrix:_mvMatrixUniformLocation matrix:mvMatrix];
}

- (void)setModelMatrix:(Matrix4D)modelMatrix {
    _modelMatrix = modelMatrix;
    var mvMatrix = _viewMatrix; mvMatrix.multiply(_modelMatrix);
	[_glContext setUniformMatrix:_mvMatrixUniformLocation matrix:mvMatrix];
}

- (void)setVertexBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_vertexAttributeLocation size:3];
}

- (void)setTexCoordBufferData:(int)bufferId {
	CPLog.error("setTexCoordBufferData not available in SimpleColorRenderer")
}

- (void)setColorBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_colorAttributeLocation size:4];
}

- (void)setElementBufferData:(int)bufferId {
	// Bind element index buffer
	[_glContext bindElementBuffer:bufferId];
}

- (void)setTexture:(int)textureId {
	// Bind the texture
	[_glContext bindTexture:textureId];
}

@end
