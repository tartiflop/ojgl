@import "OJGL/GLView.j"
@import "OJGL/GLProgram.j"
@import "OJGL/GLShadersLoader.j"
@import "OJGL/GLU.j"
@import "primitives/Sphere.j"
@import "math/Matrix3D.j"

@implementation SphereView : GLView {
	GLContext _glContext;
	GLShadersLoader _glShadersLoader;

	Sphere _sphere;

	int _vertexBufferIndex;
	int _colorBufferIndex;
	int _indicesBufferIndex;

	int _vertexAttributeIndex;
	int _colorAttributeIndex;
	int _matrixUniformIndex;

	float _angle;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	//	Load vertex and fragment shader source and prepare scene when completed
	_glShadersLoader = [[GLShadersLoader alloc] initWithShader:"Resources/vertexShader.glsl" fragmentShaderURL:"Resources/fragmentShader.glsl" target:self onComplete:@selector(loadedShaders)];
	return self;
}

- (void)loadedShaders {

	//	Get the OpenGL Context
	_glContext = [self glContext];

	//	Prepare (initialise) context
	[_glContext prepare:[0.2, 0.2, 0.2, 1] clearDepth:1.0];
	//	[_glContext setFrontFaceWinding:@"CW"];
	[_glContext enableBackfaceCulling];

	//	Create a new program
	var glProgram = [_glContext createProgram];

	//	Add shaders to program and link
	[glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[glProgram linkProgram];

	//	Get attribute indices
	_vertexAttributeIndex = [glProgram getAttributeLocation:"aVertex"];
	_colorAttributeIndex = [glProgram getAttributeLocation:"aColor"];
	_matrixUniformIndex = [glProgram getUniformLocation:"mvMatrix"];
	var perspectiveUniformIndex = [glProgram getUniformLocation:"pMatrix"];

	//	Set program to be used
	[_glContext useProgram:glProgram];

	//	Create a whopper sphere
	//	var _sphere = [[Sphere alloc] initWithGeometry:1.5 longs:300 lats:300];

	//	Create a modest sphere
	var _sphere = [[Sphere alloc] initWithGeometry:2 longs:25 lats:25];

	//	Create and initialise buffer data
	_vertexBufferIndex = [_glContext createBufferFromArray:[_sphere geometryData]];
	_colorBufferIndex = [_glContext createBufferFromArray:[_sphere colorData]];
	_indicesBufferIndex = [_glContext createBufferFromElementArray:[_sphere indexData]];

	//	reshape
	[_glContext reshape:[self width] height:[self height]];


	//	Initialise projection matrix
	var lookat = [GLU lookAt:2 eyey:5 eyez:3 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];

	var projectionMatrix = [[Matrix3D alloc] init];
	[projectionMatrix multiply:perspective m2:lookat];
	[_glContext setUniformMatrix:perspectiveUniformIndex matrix:projectionMatrix];
}

- (void)drawRect:(CPRect)dirtyRect {
	// recalculate rotation matrix
	_angle = _angle + 4 % 360;

	//	Get a new rotation matrix
	var mvMatrix = [[Matrix3D alloc] initWithRotation:_angle x:0 y:1 z:0];

	//	Clear context
	[_glContext clearBuffer];

	//	Set rotation matrix
	[_glContext setUniformMatrix:_matrixUniformIndex matrix:mvMatrix];

	//	Bind buffers to attributes
	[_glContext bindBufferToAttribute:_vertexBufferIndex attributeLocation:_vertexAttributeIndex size:3];
	[_glContext bindBufferToAttribute:_colorBufferIndex attributeLocation:_colorAttributeIndex size:4];

	//	Bind element index buffer
	[_glContext bindElementBuffer:_indicesBufferIndex];

	//	redraw
	[_glContext drawElements:[_sphere numberOfElements]];
}

@end