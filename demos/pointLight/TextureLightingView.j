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
	float _lightAngle;
	float _sphereAngle;
	
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

		_lightAngle = 0;
	}
	
	return self;
}

- (void)initScene {
		
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];

	// Create sphere with Color material
	var textureMaterial = [[TextureMaterial alloc] initWithTextureFile:"Resources/images/mars.jpg" shininess:0.7 precise:YES];
	_textureSphere = [[Sphere alloc] initWithGeometry:textureMaterial radius:2 longs:25 lats:25];
	[_textureSphere prepareGL:_glContext];
	[_textureSphere setTranslation:-2.5 y:0 z:0];
	[[RendererManager getInstance] addPrimitive:_textureSphere];
	

	// Create sphere with Color material
	var colorMaterial = [[ColorMaterial alloc] initWithHexColors:"BBBBBB" diffuse:"FFFFFF" specular:"FFFFFF" shininess:0.9 precise:YES];
	_colorSphere = [[Sphere alloc] initWithGeometry:colorMaterial radius:2 longs:25 lats:25];
	[_colorSphere prepareGL:_glContext];
	[_colorSphere setTranslation:2.5 y:0 z:0];
	[[RendererManager getInstance] addPrimitive:_colorSphere];
	

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
	[[RendererManager getInstance] setSceneAmbient:"333333"];
	

	// Initialise view and projection matrices
	var lookat = [GLU lookAt:0 eyey:4 eyez:6 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
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

	// rotate spheres
	[_textureSphere setRotation:_sphereAngle x:0 y:1 z:0];

	[_light1 setPosition:[6 * Math.sin(_lightAngle * Math.PI / 60), 4 * Math.cos(_lightAngle * Math.PI / 60), 2]];
	[_light2 setPosition:[6 * Math.cos(_lightAngle * Math.PI / 90), 4 * Math.sin(_lightAngle * Math.PI / 45), 3]];
	[_light3 setPosition:[6 * Math.cos(_lightAngle * Math.PI / 60), 4 * Math.cos(_lightAngle * Math.PI / 120), 3]];

	CPLog.info(5 * Math.cos(_lightAngle * Math.PI / 90));
	
	// Render the scene
	[[RendererManager getInstance] render];

	_sphereAngle = (_sphereAngle + 0.5) % 360;
	_lightAngle = _lightAngle + 1 % 360;
	
	// flush
	[_glContext flush];
}

@end
