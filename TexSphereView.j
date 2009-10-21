@import "OJGL/GLView.j"
@import "OJGL/GLProgram.j"
@import "OJGL/GLShadersLoader.j"
@import "OJGL/GLU.j"
@import "OJGL/GLTexture.j"
@import "primitives/TextureSphere.j"
@import "math/Matrix3D.j"

@implementation TexSphereView : GLView {
	GLContext _glContext;
	GLShadersLoader _glShadersLoader;

	Sphere _sphere;
	
	int _vertexBufferId;
	int _texCoordBufferId;
	int _indicesBufferId;
	GLTexture _texture;
	
	int _vertexAttributeLocation;
	int _texCoordAttributeLocation;
	int _matrixUniformLocation;
	
	float _angle;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	// Load vertex and fragment shader source and prepare scene when completed
	_glShadersLoader = [[GLShadersLoader alloc] initWithShader:"Resources/vertexTextureShader.glsl" fragmentShaderURL:"Resources/fragmentTextureShader.glsl" target:self onComplete:@selector(loadedShaders)];
	return self;
}

- (void)loadedShaders {
	
	// Get the OpenGL Context
	_glContext = [self glContext];
	
	// Prepare (initialise) context
	[_glContext prepare:[0.2, 0.2, 0.2, 1] clearDepth:1.0];
	//[_glContext setFrontFaceWinding:@"CW"];
	[_glContext enableBackfaceCulling];

	// Create a new program
	var glProgram = [_glContext createProgram];
	
	// Add shaders to program and link
	[glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[glProgram linkProgram];
	
	// Create the texture map from an image
	_texture = [[GLTexture alloc] initWithFilename:"Resources/mars.jpg" glContext:_glContext];
   
	// Get attribute locations
	_vertexAttributeLocation = [glProgram getAttributeLocation:"aVertex"];
	_texCoordAttributeLocation = [glProgram getAttributeLocation:"aTexCoord"];
	_matrixUniformLocation = [glProgram getUniformLocation:"mvMatrix"];
	var perspectiveUniformLocation = [glProgram getUniformLocation:"pMatrix"];

	// Set up the texture sampler
	[_glContext setUniformSampler:[glProgram getUniformLocation:"sTexture"]];
	[_glContext enableTexture];
	
	// Set program to be used
	[_glContext useProgram:glProgram];

	// Create a modest sphere
	var _sphere = [[TextureSphere alloc] initWithGeometry:2 longs:25 lats:25];
	
	// Create and initialise buffer data
	_vertexBufferId = [_glContext createBufferFromArray:[_sphere geometryData]];
	_texCoordBufferId = [_glContext createBufferFromArray:[_sphere texCoordData]];
	_indicesBufferId = [_glContext createBufferFromElementArray:[_sphere indexData]];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise projection matrix
	var lookat = [GLU lookAt:1 eyey:4 eyez:4 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];
	var projectionMatrix = [[Matrix3D alloc] init];
	[projectionMatrix multiply:perspective m2:lookat];

	// Set the projection matrix
	[_glContext setUniformMatrix:perspectiveUniformLocation matrix:projectionMatrix];
	
}

- (void)drawRect:(CPRect)dirtyRect {
	// recalculate rotation matrix
	_angle = _angle + 2 % 360;

	// Get a new rotation matrix
	var mvMatrix = [[Matrix3D alloc] initWithRotation:_angle x:0 y:1 z:0];

	// Clear context
	[_glContext clearBuffer];
	
	// Set rotation matrix
	[_glContext setUniformMatrix:_matrixUniformLocation matrix:mvMatrix];

	// Bind buffers to attributes
	[_glContext bindBufferToAttribute:_vertexBufferId attributeLocation:_vertexAttributeLocation size:3];
	[_glContext bindBufferToAttribute:_texCoordBufferId attributeLocation:_texCoordAttributeLocation size:2];
	
	// Bind element index buffer
	[_glContext bindElementBuffer:_indicesBufferId];

	// Bind the texture
	[_glContext bindTexture:[_texture textureId]];
	
	// redraw
	[_glContext drawElements:[_sphere numberOfElements]];
}

@end
