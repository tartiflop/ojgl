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
    int _mvMatrixUniformLocation;
    int _mvpMatrixUniformLocation;
	int _vertexAttributeLocation;
	
	Matrix4D _viewMatrix;
	Matrix4D _modelMatrix;
	Matrix4D _projectionMatrix;
	Matrix4D _mvMatrix;
	Matrix4D _mvpMatrix;
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
        _projectionMatrix = new Matrix4D();
       	_mvMatrix = new Matrix4D();
       	_mvpMatrix = new Matrix4D();
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

    _mvMatrixUniformLocation = [_glProgram getUniformLocation:"u_mvMatrix"];
    _mvpMatrixUniformLocation = [_glProgram getUniformLocation:"u_mvpMatrix"];
	_vertexAttributeLocation = [_glProgram getAttributeLocation:"a_vertex"];
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
	_projectionMatrix = projectionMatrix;
	
	[self setupMatrices];
}

- (void)setViewMatrix:(Matrix4D)viewMatrix {
	_viewMatrix = viewMatrix;
	
	[self setupMatrices];
}

- (void)setModelMatrix:(Matrix4D)modelMatrix {
	_modelMatrix = modelMatrix;
	
	[self setupMatrices];
}

- (void)setupMatrices {
	
	// calculate model-view matrix
	_mvMatrix = new Matrix4D(_viewMatrix);
	_mvMatrix.multiply(_modelMatrix);
	
	// calculate model-view-projection
	_mvpMatrix = new Matrix4D(_projectionMatrix);
	_mvpMatrix.multiply(_mvMatrix);
	
	// Set the matrices
	[_glContext setUniformMatrix4:_mvpMatrixUniformLocation matrix:_mvpMatrix];
	[_glContext setUniformMatrix4:_mvMatrixUniformLocation matrix:_mvMatrix];
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
