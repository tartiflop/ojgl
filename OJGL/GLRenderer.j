@import <Foundation/CPObject.j>
@import "GLProgram.j"
@import "GLShadersLoader.j"

@implementation GLRenderer : CPObject {
	id _target;
	SEL _onComplete;

	GLProgram _glProgram;
	GLContext _glContext;
	GLShadersLoader _glShadersLoader;

	CPString _vertexShaderFile;
	CPString _fragmentShaderFile;
}

- (id)initWithContext:(GLContext)context vertexShaderFile:(CPString)vertexShaderFile fragmentShaderFile:(CPString)fragmentShaderFile {
	self = [super init];
	
	if (self) {
		_glContext = context;
		_glProgram = [_glContext createProgram];
		_vertexShaderFile = vertexShaderFile;
		_fragmentShaderFile = fragmentShaderFile;
	}
	
	return self;
}

- (void)load:(id)target onComplete:(SEL)onComplete {
	_target = target;
	_onComplete = onComplete;
	
	// Load vertex and fragment shader source and prepare scene when completed
	_glShadersLoader = [[GLShadersLoader alloc] initWithShader:_vertexShaderFile fragmentShaderURL:_fragmentShaderFile target:self onComplete:@selector(onShadersLoaded)];
	
}

- (void)onShadersLoaded {
}

- (void)callback {
	// Callback
	objj_msgSend(_target, _onComplete);
}

- (void)setActive {
	// Set program to be used
	[_glContext useProgram:_glProgram];
}

- (void)drawElements:(int)numberOfElements {
	// redraw
	[_glContext drawElements:numberOfElements];

}

- (void)setProjectionMatrix:(Matrix4D)projectionMatrix {
}

- (void)setModelViewMatrix:(Matrix4D)mvMatrix {
}

- (void)setVertexBufferData:(int)bufferId {
}

- (void)setTexCoordBufferData:(int)bufferId {
}

- (void)setColorBufferData:(int)bufferId {
}

- (void)setElementBufferData:(int)bufferId {
}

- (void)setTexture:(int)textureId {
}

@end
