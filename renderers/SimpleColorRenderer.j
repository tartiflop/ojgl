@import "../OJGL/GLRenderer.j"

@implementation SimpleColorRenderer : GLRenderer {
	int _colorAttributeLocation;
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/shaders/basicColor.vsh" fragmentShaderFile:@"Resources/shaders/basicColor.fsh"];
	return self;
}

- (void)onShadersLoaded {
	[super onShadersLoaded];

	// Get attribute locations
	_colorAttributeLocation = [_glProgram getAttributeLocation:"a_color"];

	// Callback
	[super callback]
}

- (void)setColorBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_colorAttributeLocation size:4];
}
@end
