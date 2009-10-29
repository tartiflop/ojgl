@import "OJGL/GLView.j"
@import "OJGL/GLU.j"
@import "primitives/Sphere.j"
@import "materials/TextureMaterial.j"
@import "materials/RandomColorMaterial.j"
@import "renderers/SimpleTexRenderer.j"
@import "renderers/SimpleColorRenderer.j"

@implementation SphereView : GLView {
	GLContext _glContext;
	SimpleTexRenderer _textureRenderer;
	SimpleColorRenderer _colorRenderer;
	
	Sphere _textureSphere;
	Sphere _colorSphere;
	float _angle;
	BOOL _ready;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_ready = NO;
		
		// Get the OpenGL Context
		_glContext = [self glContext];

		// Initialise the color renderer, load texture renderer when ready
		_colorRenderer = [[SimpleColorRenderer alloc] initWithContext:_glContext];
		[_colorRenderer load:self onComplete:@selector(initTextureRenderer)]
	}
	
	return self;
}

- (void)initTextureRenderer {
	
	// Initialise the texture renderer, create scene when ready
	_textureRenderer = [[SimpleTexRenderer alloc] initWithContext:_glContext];
	[_textureRenderer load:self onComplete:@selector(initScene)]
}

- (void)initScene {
		
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];
	[_glContext enableTexture];

	// Create sphere with Texture material
	var textureMaterial = [[TextureMaterial alloc] initWithTextureFile:"Resources/mars.jpg"];
	var _textureSphere = [[Sphere alloc] initWithGeometry:textureMaterial radius:1.2 longs:25 lats:25];
	[_textureSphere prepareGL:_glContext];
	
	// Create sphere with Color material
	var colorMaterial = [[RandomColorMaterial alloc] init];
	var _colorSphere = [[Sphere alloc] initWithGeometry:colorMaterial radius:1.2 longs:25 lats:25];
	[_colorSphere prepareGL:_glContext];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise projection matrix
	var lookat = [GLU lookAt:3.5 eyey:4 eyez:20 centerx:0 centery:-3 centerz:-25 upx:0 upy:1 upz:0];
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];
//	var ortho = [GLU ortho:-16 right:16 bottom:-12 top:12 near:1 far:10000];

	var projectionMatrix = new Matrix4D(perspective);
	projectionMatrix.multiply(lookat);
	
	// Send projection matrices to the renderers (shaders)
	[_textureRenderer setActive];
	[_textureRenderer setProjectionMatrix:projectionMatrix];
	[_colorRenderer setActive];
	[_colorRenderer setProjectionMatrix:projectionMatrix];

	_ready = YES;
}

- (void)drawRect:(CPRect)dirtyRect {
	
	// Only render the scene if ready
	if (!_ready) {
		return;
	}
	// recalculate rotation matrix
	_angle = _angle + 2 % 360;
	[_textureSphere resetTransformation];
	[_textureSphere rotate:_angle x:0 y:1 z:0];
	[_colorSphere resetTransformation];
	[_colorSphere rotate:_angle x:0 y:1 z:0];

	// Clear context
	[_glContext clearBuffer];


	// Multiple renderings of texture sphere
	[_textureRenderer setActive];
	for (var k = 0; k < 4; k++) {
		for (var j = 0; j < 4; j++) {
			for (var i = 0; i < 4; i++) {
				
				if ((i + j + k) % 2 == 0) {
					// Translate sphere, activate the texture renderer and render the texture sphere
					[_textureSphere translateTo:((i - 1.5) * 4) y:((j - 1.5) * 4) z:(-k * 5)];
					[_textureSphere render:_textureRenderer];
				}
			}
		}		
	}		
	
	// Multiple renderings of color sphere
	[_colorRenderer setActive];
	for (var k = 0; k < 4; k++) {
		for (var j = 0; j < 4; j++) {
			for (var i = 0; i < 4; i++) {
				
				if ((i + j + k) % 2 == 1) {
					// Translate sphere, activate the color renderer and render the color sphere
					[_colorSphere translateTo:((i - 1.5) * 4) y:((j - 1.5) * 4) z:(-k * 5)];
					[_colorSphere render:_colorRenderer];
				}
			}
		}		
	}		
	
	// flush
//	[_glContext flush];
// Flush performed in GLView?
}


@end
