@import "OJGL/GLView.j"
@import "OJGL/GLU.j"
@import "primitives/Sphere.j"
@import "materials/TextureMaterial.j"
@import "materials/RandomColorMaterial.j"
@import "math/Matrix3D.j"
@import "renderers/SimpleTexRenderer.j"
@import "renderers/SimpleColorRenderer.j"

@implementation SphereView : GLView {
	GLContext _glContext;
	SimpleTexRenderer _textureRenderer;
	SimpleColorRenderer _colorRenderer;
	
	Sphere _textureSphere;
	Sphere _colorSphere;
	float _angle;
	int _rendererCount;
	
	Matrix3D _projectionMatrix;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_rendererCount = 0;
		
		// Get the OpenGL Context
		_glContext = [self glContext];

		_colorRenderer = [[SimpleColorRenderer alloc] initWithContext:_glContext];
		[_colorRenderer load:self onComplete:@selector(initScene)]
		
		// Initialise the renderer
		_textureRenderer = [[SimpleTexRenderer alloc] initWithContext:_glContext];
		[_textureRenderer load:self onComplete:@selector(initScene)]
	}
	
	return self;
}

- (void)initScene {
	
	_rendererCount++;
	if (_rendererCount != 2) {
		return;
	}
		
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];
	[_glContext enableTexture];

	// Create the texture material
	var textureMaterial = [[TextureMaterial alloc] initWithTextureFile:"Resources/mars.jpg"];
	var colorMaterial = [[RandomColorMaterial alloc] init];
	
	// Create a modest sphere, associate with Texture material
	var _textureSphere = [[Sphere alloc] initWithGeometry:textureMaterial radius:2 longs:25 lats:25];
	[_textureSphere prepareGL:_glContext];
	
	var _colorSphere = [[Sphere alloc] initWithGeometry:colorMaterial radius:2 longs:25 lats:25];
	[_colorSphere prepareGL:_glContext];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise projection matrix
	var lookat = [GLU lookAt:0 eyey:7 eyez:7 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];
	_projectionMatrix = [[Matrix3D alloc] init];
	[_projectionMatrix multiply:perspective m2:lookat];

}

- (void)drawRect:(CPRect)dirtyRect {
	
	try {
		// recalculate rotation matrix
		_angle = _angle + 2 % 360;
		[_textureSphere setRotation:_angle];
		[_textureSphere translate:-3 y:0 z:0];
		[_colorSphere setRotation:_angle];
		[_colorSphere translate:3 y:0 z:0];
	
		// Clear context
		[_glContext clearBuffer];
		
		// Activate the texture renderer with the projection matrix and render the texture sphere
		[_textureRenderer setActive];
		[_textureRenderer setProjectionMatrix:_projectionMatrix];
		[_textureSphere render:_textureRenderer];

		// Activate the color renderer with the projection matrix and render the color sphere
		[_colorRenderer setActive];
		[_colorRenderer setProjectionMatrix:_projectionMatrix];
		[_colorSphere render:_colorRenderer];
		
		// flush
		[_glContext flush];
	} catch (e) {
		CPLog.error("Caught exception during rendering: " + e)
	}
}

@end
