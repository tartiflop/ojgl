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

	GLTexture _texture;
	
	float _angle;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		// Get the OpenGL Context
		_glContext = [self glContext];
		
		// Initialise the renderer
		_renderer = [[SimpleTexRenderer alloc] initWithContext:_glContext];
		[_renderer load:self onComplete:@selector(initScene)]
	}
	
	return self;
}

- (void)initScene {
	
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];
	[_glContext enableTexture];

	// Create the texture map from an image
	_texture = [[GLTexture alloc] initWithFilename:"Resources/mars.jpg" glContext:_glContext];

	// Create a modest sphere
	var _sphere = [[TextureSphere alloc] initWithGeometry:2 longs:25 lats:25];
	[_sphere initialiseBuffers:_glContext];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise projection matrix
	var lookat = [GLU lookAt:1 eyey:4 eyez:4 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];
	var projectionMatrix = [[Matrix3D alloc] init];
	[projectionMatrix multiply:perspective m2:lookat];

	// Set the projection matrix
	[_renderer setActive];
	[_renderer setProjectionMatrix:projectionMatrix];
	
}

- (void)drawRect:(CPRect)dirtyRect {
	
	// Clear context
	[_glContext clearBuffer];

	// Bind the texture
	[_glContext bindTexture:[_texture textureId]];
	
	// recalculate rotation matrix
	_angle = _angle + 2 % 360;
	[_sphere setRotation:_angle];

	// Render sphere
	[_sphere render:_renderer];
	
	// flush
	[_glContext flush];
}

@end
