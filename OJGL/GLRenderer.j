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
	
	
	Array _primitivesToRender;
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
       	
       	_primitivesToRender = [];
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
	_projectionMatrix = new Matrix4D(projectionMatrix);
	
	[self setupMatrices];
}

- (void)setViewMatrix:(Matrix4D)viewMatrix {
	_viewMatrix = new Matrix4D(viewMatrix);
	
	[self setupMatrices];
}

- (void)setModelMatrix:(Matrix4D)modelMatrix {
	_modelMatrix = new Matrix4D(modelMatrix);
	
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


- (void)addPrimitive:(GLPrimitive)primitive {
	_primitivesToRender.push(primitive);
}

- (int)addLight:(GLLight)light {
}

- (void)setSceneAmbient:(String)ambient {
}

- (void)renderLights {
}

- (void)render {
	// Set as active renderer
	[self setActive];
	
	// Render lights if needed
	[self renderLights];
	
	for (var i = 0; i < _primitivesToRender.length; i++) {

		// Prepare the material to be rendered
		[[_primitivesToRender[i] getMaterial] prepareRenderer];

		// Set model view matrix
		[self setModelMatrix:[_primitivesToRender[i] getTransformation]];
		
		// Send the vertex data to the renderer
		[self setVertexBufferData:[_primitivesToRender[i] getVertexBufferId]];
		
		// Bind element index buffer
		[self setElementBufferData:[_primitivesToRender[i] getIndicesBufferId]];

		// render elements
		[self drawElements:[_primitivesToRender[i] numberOfElements]];
	}
}

@end
