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
	int _perspectiveUniformLocation;
    int _mvMatrixUniformLocation;
	int _vertexAttributeLocation;
    Matrix4D _viewMatrix;
    Matrix4D _modelMatrix;
}

- (id)initWithContext:(GLContext)context vertexShaderFile:(CPString)vertexShaderFile fragmentShaderFile:(CPString)fragmentShaderFile {
	self = [super init];
	
	if (self) {
		_glContext = context;
		_glProgram = [_glContext createProgram];
		_vertexShaderFile = vertexShaderFile;
		_fragmentShaderFile = fragmentShaderFile;
       	_modelMatrix = new Matrix4D();
        _viewMatrix = new Matrix4D();
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
	// Add shaders to program and link
	[_glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[_glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[_glProgram linkProgram];

	_perspectiveUniformLocation = [_glProgram getUniformLocation:"pMatrix"];
    _mvMatrixUniformLocation = [_glProgram getUniformLocation:"mvMatrix"];
	_vertexAttributeLocation = [_glProgram getAttributeLocation:"aVertex"];
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
	// Set the projection matrix
	[_glContext setUniformMatrix:_perspectiveUniformLocation matrix:projectionMatrix];
}

- (void)setViewMatrix:(Matrix4D)viewMatrix {
    _viewMatrix = viewMatrix;
    var mvMatrix = new Matrix4D(_viewMatrix); 
    mvMatrix.multiply(_modelMatrix);
	[_glContext setUniformMatrix:_mvMatrixUniformLocation matrix:mvMatrix];
}

- (void)setModelMatrix:(Matrix4D)modelMatrix {
    _modelMatrix = modelMatrix;
    var mvMatrix = new Matrix4D(_viewMatrix); 
    mvMatrix.multiply(_modelMatrix);
	[_glContext setUniformMatrix:_mvMatrixUniformLocation matrix:mvMatrix];
}

- (void)setVertexBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_vertexAttributeLocation size:3];
}

- (void)setElementBufferData:(int)bufferId {
	// Bind element index buffer
	[_glContext bindElementBuffer:bufferId];
}
@end
