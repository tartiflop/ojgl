@import "../../OJGL/GLView.j"
@import "../../OJGL/GLU.j"
@import "../../OJGL/GLLight.j"
@import "../../primitives/Sphere.j"
@import "../../materials/TextureMaterial.j"
@import "../../materials/ColorMaterial.j"
@import "../../renderers/RendererManager.j"

@implementation TextureLightingView : GLView {
	GLContext _glContext;

	GLLight _light1;
	GLLight _light2;
	GLLight _light3;
	float _angle;
	
	BOOL _ready;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_ready = NO;
		
		// Get the OpenGL Context
		_glContext = [self glContext];

		// Initialise the renderer manager
		[[RendererManager alloc] initWithContext:_glContext];
		
		// build the scene
		[self initScene];

		_angle = 0;
	}
	
	return self;
}

- (void)initScene {
		
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];

	// Create sphere with Color material
	var textureMaterial = [[TextureMaterial alloc] initWithTextureFileAndShininess:"Resources/images/mars.jpg" shininess:0.7];
	var textureSphere = [[Sphere alloc] initWithGeometry:textureMaterial radius:2 longs:6 lats:6];
	[textureSphere prepareGL:_glContext];
	[textureSphere setTranslation:-4 y:0 z:0];
	[[RendererManager getInstance] addPrimitive:textureSphere];
	

	// Create sphere with Color material
	var colorMaterial = [[ColorMaterial alloc] initWithHexColors:"BBBBBB" diffuse:"FFFFFF" specular:"FFFFFF" shininess:0.7];
	var colorSphere = [[Sphere alloc] initWithGeometry:colorMaterial radius:2 longs:25 lats:25];
	[colorSphere prepareGL:_glContext];
	[colorSphere setTranslation:4 y:0 z:0];
	[[RendererManager getInstance] addPrimitive:colorSphere];
	

	// Create the lights
	_light1 = [[GLLight alloc] initWithHexColor:"0000FF" specularColor:"FFFFFF"];
	[_light1 setAttenuation:0.02];
	[[RendererManager getInstance] addLight:_light1];
	
	_light2 = [[GLLight alloc] initWithHexColor:"FF0000" specularColor:"FFFFFF"];
	[_light2 setAttenuation:0.02];
	[[RendererManager getInstance] addLight:_light2];
	
	_light3 = [[GLLight alloc] initWithHexColor:"00FF00" specularColor:"FFFFFF"];
	[_light3 setAttenuation:0.02];
	[[RendererManager getInstance] addLight:_light3];

	// Set the scene ambient color
	[[RendererManager getInstance] setSceneAmbient:"222222"];
	

	// Initialise view and projection matrices
	var lookat = [GLU lookAt:0 eyey:0 eyez:15 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	[[RendererManager getInstance] setViewMatrix:lookat];
	
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];
	[[RendererManager getInstance] setProjectionMatrix:perspective];

	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	_ready = YES;
}

- (void)drawRect:(CPRect)dirtyRect {
	
	// Only render the scene if ready
	if (!_ready) {
		return;
	}
	
	// Clear context
	[_glContext clearBuffer];

	[_light1 setPosition:[2 * Math.cos(_angle * Math.PI / 90), 10 * Math.sin(_angle * Math.PI / 90), 5]];
	[_light2 setPosition:[10 * Math.sin(_angle * Math.PI / 90), 2 * Math.cos(_angle * Math.PI / 30), 5]];
	[_light3 setPosition:[5 * Math.cos(_angle * Math.PI / 60), 5 * Math.cos(_angle * Math.PI / 120), 5]];

	// Render the scene
	[[RendererManager getInstance] render];

	_angle = _angle + 1 % 360;
	
	// flush
	[_glContext flush];
}

@end
