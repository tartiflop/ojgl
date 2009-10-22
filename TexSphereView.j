@import "OJGL/GLView.j"
@import "OJGL/GLU.j"
@import "OJGL/GLTexture.j"
@import "primitives/TextureSphere.j"
@import "math/Matrix3D.j"
@import "SimpleTexRenderer.j"

@implementation TexSphereView : GLView {
	GLContext _glContext;
	SimpleTexRenderer _renderer;
	
	Sphere _sphere;
	
	int _vertexBufferId;
	int _texCoordBufferId;
	int _indicesBufferId;
	GLTexture _texture;
	
	float _angle;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	// Get the OpenGL Context
	_glContext = [self glContext];
	
	// Initialise the renderer
	_renderer = [[SimpleTexRenderer alloc] initWithContext:_glContext];
	[_renderer load:self onComplete:@selector(rendererReady)]
	
	return self;
}

- (void)rendererReady {
	
	// Prepare (initialise) context
	[_glContext prepare:[0.2, 0.2, 0.2, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];
	[_glContext enableTexture];

	// Create the texture map from an image
	_texture = [[GLTexture alloc] initWithFilename:"Resources/mars.jpg" glContext:_glContext];

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
	[_renderer setProjectionMatrix:projectionMatrix];
	
}

- (void)drawRect:(CPRect)dirtyRect {

	// Clear context
	[_glContext clearBuffer];

	// recalculate rotation matrix
	_angle = _angle + 2 % 360;

	// Get a new rotation matrix
	var mvMatrix = [[Matrix3D alloc] initWithRotation:_angle x:0 y:1 z:0];
	[_renderer setModelViewMatrix:mvMatrix];

	// Send the data to the renderer
	[_renderer setVertexBufferData:_vertexBufferId];
	[_renderer setTexCoordBufferData:_texCoordBufferId];
	
	// Bind element index buffer
	[_glContext bindElementBuffer:_indicesBufferId];

	// Bind the texture
	[_glContext bindTexture:[_texture textureId]];
	
	// redraw
	[_glContext drawElements:[_sphere numberOfElements]];
}

@end
