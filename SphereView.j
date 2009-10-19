@import "OJGL/GLView.j"
@import "OJGL/GLProgram.j"
@import "OJGL/GLMatrix.j"
@import "OJGL/GLShadersLoader.j"
@import "primitives/SphereBurst.j"

@implementation SphereView : GLView {
	GLContext _glContext;
	GLShadersLoader _glShadersLoader;

	SphereBurst _sphere;
	
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
	// Load vertex and fragment shader source and prepare scene when completed
	_glShadersLoader = [[GLShadersLoader alloc] initWithShader:"Resources/vertexShader.glsl" fragmentShaderURL:"Resources/fragmentShader.glsl" target:self onComplete:@selector(loadedShaders)];
	return self;
}

- (void)loadedShaders {

	// Get the OpenGL Context
	_glContext = [self glContext];
	
	// Prepare (initialise) context
	[_glContext prepare:[0.2, 0.2, 0.2, 1] clearDepth:1.0];
	//[_glContext enableBackfaceCulling:@"CW"];

	// Create a new program
	var glProgram = [_glContext createProgram];
	
	// Add shaders to program and link
	[glProgram addShaderText:[_glShadersLoader vertexShader] shaderType:GL_VERTEX_SHADER];
	[glProgram addShaderText:[_glShadersLoader fragmentShader] shaderType:GL_FRAGMENT_SHADER];
	[glProgram linkProgram];
   
	// Get attribute indices
	_vertexAttributeIndex = [glProgram getAttributeLocation:"aVertex"];
	_colorAttributeIndex = [glProgram getAttributeLocation:"aColor"];
	_matrixUniformIndex = [glProgram getUniformLocation:"mvMatrix"];
	var perspectiveUniformIndex = [glProgram getUniformLocation:"pMatrix"];
	
	// Set program to be used
	[_glContext useProgram:glProgram];
	
	// Create a whopper sphere
//	var _sphere = [[Sphere alloc] initWithGeometry:1.5 longs:300 lats:300];

	// Create a modest sphere
	var _sphere = [[Sphere alloc] initWithGeometry:1.5 longs:50 lats:50];
	
	// Create and initialise buffer data
	_vertexBufferIndex = [_glContext createBufferFromArray:[_sphere geometryData]];
	_colorBufferIndex = [_glContext createBufferFromArray:[_sphere colorData]];
	_indicesBufferIndex = [_glContext createBufferFromElementArray:[_sphere indexData]];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Set up camera position and perspective
	var perspectiveMatrix = [[GLMatrix alloc] initWithLookat:0 eyey:3 eyez:-2 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	[perspectiveMatrix perspective:60 aspect:[self width]/[self height] zNear:1 zFar:10000];
	[_glContext setUniformMatrix:perspectiveUniformIndex matrix:perspectiveMatrix];
}

- (void)drawRect:(CPRect)dirtyRect {
	// recalculate rotation matrix
	_angle = _angle + 2 % 360;

	var mvMatrix = [[GLMatrix alloc] initWithRotation:_angle x:0 y:1 z:0];

	// Clear context
	[_glContext clearBuffer];
	
	// Set rotation matrix
	[_glContext setUniformMatrix:_matrixUniformIndex matrix:mvMatrix];

	// Bind buffers to attributes
	[_glContext bindBufferToAttribute:_vertexBufferIndex attributeIndex:_vertexAttributeIndex size:3];
	[_glContext bindBufferToAttribute:_colorBufferIndex attributeIndex:_colorAttributeIndex size:4];
	
	// Bind element index buffer
	[_glContext bindElementBuffer:_indicesBufferIndex];
 
	// redraw
	[_glContext drawElements:[_sphere numberOfElements]];
}

@end
