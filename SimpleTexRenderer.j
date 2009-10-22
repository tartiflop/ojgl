@import <Foundation/CPObject.j>
@import "OJGL/GLProgram.j"
@import "OJGL/GLShadersLoader.j"
@import "math/Matrix3D.j"

@implementation SimpleTexRenderer : CPObject {
	id _target;
	SEL _onComplete;

	GLProgram _glProgram;
	GLContext _glContext;
	GLShadersLoader _glShadersLoader;

	CPString _vertexShaderFile;
	CPString _fragmentShaderFile;
	
	int _vertexAttributeLocation;
	int _texCoordAttributeLocation;
	int _matrixUniformLocation;
	int _perspectiveUniformLocation;
	int _samplerUniformLocation;

}

- (id)initWithContext:(GLContext)context {
	self = [super init];
	
	if (self) {
		_glContext = context;
		_glProgram = [_glContext createProgram];

		_vertexShaderFile = @"Resources/vertexTextureShader.glsl";
		_fragmentShaderFile = @"Resources/fragmentTextureShader.glsl";
	}
	
	return self;
}

- (void)load:(id)target onComplete:(SEL)onComplete {
	_target = target;
	_onComplete = onComplete;
	
	// Load vertex and fragment shader source and prepare scene when completed
	_glShadersLoader = [[GLShadersLoader alloc] initWithShader:_vertexShaderFile fragmentShaderURL:_fragmentShaderFile target:self onComplete:@selector(loadedShaders)];
	
}

- (void)loadedShaders {
	
	// Add shaders to program and link
	[_glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[_glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[_glProgram linkProgram];

	// Get attribute locations
	_vertexAttributeLocation = [_glProgram getAttributeLocation:"aVertex"];
	_texCoordAttributeLocation = [_glProgram getAttributeLocation:"aTexCoord"];
	_matrixUniformLocation = [_glProgram getUniformLocation:"mvMatrix"];
	_perspectiveUniformLocation = [_glProgram getUniformLocation:"pMatrix"];

	// Set up the texture sampler
	[_glContext setUniformSampler:[_glProgram getUniformLocation:"sTexture"]];

	// Set program to be used
	[_glContext useProgram:_glProgram];

	// Callback
	objj_msgSend(_target, _onComplete);
}

- (void)setProjectionMatrix:(Matrix3D)projectionMatrix {
	// Set the projection matrix
	[_glContext setUniformMatrix:_perspectiveUniformLocation matrix:projectionMatrix];

}

- (void)setModelViewMatrix:(Matrix3D)mvMatrix {
	// Set rotation matrix
	[_glContext setUniformMatrix:_matrixUniformLocation matrix:mvMatrix];
}

- (void)setVertexBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_vertexAttributeLocation size:3];
}

- (void)setTexCoordBufferData:(int)bufferId {
	// Bind the texture coordinates buffer data to the texcoord attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_texCoordAttributeLocation size:2];
}

@end
