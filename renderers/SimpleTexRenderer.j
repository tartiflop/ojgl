@import "../OJGL/GLRenderer.j"

@implementation SimpleTexRenderer : GLRenderer {
	int _vertexAttributeLocation;
	int _texCoordAttributeLocation;
	int _mvMatrixUniformLocation;
	int _perspectiveUniformLocation;
	int _samplerUniformLocation;
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/vertexTextureShader.glsl" fragmentShaderFile:@"Resources/fragmentTextureShader.glsl"];
	return self;
}


- (void)onShadersLoaded {
	
	// Add shaders to program and link
	[_glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[_glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[_glProgram linkProgram];

	// Get attribute locations
	_vertexAttributeLocation = [_glProgram getAttributeLocation:"aVertex"];
	_texCoordAttributeLocation = [_glProgram getAttributeLocation:"aTexCoord"];
	_mvMatrixUniformLocation = [_glProgram getUniformLocation:"mvMatrix"];
	_perspectiveUniformLocation = [_glProgram getUniformLocation:"pMatrix"];

	// Set up the texture sampler
	[_glContext setUniformSampler:[_glProgram getUniformLocation:"sTexture"]];

	// Callback
	[super callback]
}


- (void)setProjectionMatrix:(Matrix4D)projectionMatrix {
	// Set the projection matrix
	[_glContext setUniformMatrix:_perspectiveUniformLocation matrix:projectionMatrix];

}

- (void)setVertexBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_vertexAttributeLocation size:3];
}

- (void)setTexCoordBufferData:(int)bufferId {
	// Bind the texture coordinates buffer data to the texcoord attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_texCoordAttributeLocation size:2];
}

- (void)setColorBufferData:(int)bufferId {
	CPLog.error("setColorBufferData not available in SimpleTexRenderer")
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
