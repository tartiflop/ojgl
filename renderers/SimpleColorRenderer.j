@import "../OJGL/GLRenderer.j"

@implementation SimpleColorRenderer : GLRenderer {
	int _colorAttributeLocation;
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/vertexShader.glsl" fragmentShaderFile:@"Resources/fragmentShader.glsl"];
	return self;
}


- (void)onShadersLoaded {
	[super onShadersLoaded];

	// Get attribute locations
	_colorAttributeLocation = [_glProgram getAttributeLocation:"aColor"];

	// Callback
	[super callback]
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
