@import "../OJGL/GLRenderer.j"

@implementation SimpleTexRenderer : GLRenderer {
	int _texCoordAttributeLocation;
	int _samplerUniformLocation;
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/vertexTextureShader.glsl" fragmentShaderFile:@"Resources/fragmentTextureShader.glsl"];
	return self;
}

- (void)onShadersLoaded {
    [super onShadersLoaded];

	// Get attribute locations
	_texCoordAttributeLocation = [_glProgram getAttributeLocation:"aTexCoord"];

	// Set up the texture sampler
	[_glContext setUniformSampler:[_glProgram getUniformLocation:"sTexture"]];

	// Callback
	[super callback]
}

- (void)setTexCoordBufferData:(int)bufferId {
	// Bind the texture coordinates buffer data to the texcoord attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_texCoordAttributeLocation size:2];
}

- (void)setTexture:(int)textureId {
	// Bind the texture
	[_glContext bindTexture:textureId];
}

@end
