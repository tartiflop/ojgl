@import "../../OJGL/GLView.j"
@import "../../OJGL/GLU.j"
@import "../../OJGL/GLLight.j"
@import "../../primitives/Sphere.j"
@import "../../materials/TextureMaterial.j"
@import "../../renderers/RendererManager.j"

@implementation LightingDemoView : GLView {
	GLContext _glContext;

	GLLight _blueLight;
	GLLight _redLight;
	GLLight _greenLight;
	GLLight _yellowLight;
	GLLight _cyanLight;
	GLLight _magentaLight;
	
	float _lightAngle;
	float _sphereAngle;
	
	Array _sceneObjects;
	
	BOOL _ready;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_ready = NO;
		
		// Get the OpenGL Context
		_glContext = [self glContext];

		_sceneObjects = [];
		
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

	// Create the spheres with texture materials
	for (var k = 0; k < 3; k++) {
		for (var j = 0; j < 3; j++) {
			for (var i = 0; i < 3; i++) {

				var textureMaterial = [[TextureMaterial alloc] initWithTextureFile:"Resources/images/mars.jpg" shininess:0.7 precise:YES];
				var primitive = [[Sphere alloc] initWithGeometry:textureMaterial radius:1.3 longs:25 lats:25];
                [primitive setTranslation:((i - 1) * 4) y:((j - 1) * 4) z:((k - 1) * 4)];

				[primitive prepareGL:_glContext];
				[[RendererManager getInstance] addPrimitive:primitive];
				_sceneObjects.push(primitive);
			}
		}		
	}		
	
	
	// Create the lights
	_blueLight = [[GLLight alloc] initWithHexColor:"0000FF" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:_blueLight];
	
	_redLight = [[GLLight alloc] initWithHexColor:"FF0000" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:_redLight];
	
	_greenLight = [[GLLight alloc] initWithHexColor:"00FF00" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:_greenLight];
	
	_yellowLight = [[GLLight alloc] initWithHexColor:"FFFF00" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:_yellowLight];
	
	_cyanLight = [[GLLight alloc] initWithHexColor:"00FFFF" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:_cyanLight];
	
	_magentaLight = [[GLLight alloc] initWithHexColor:"FF00FF" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:_magentaLight];
	
	var whiteLight = [[GLLight alloc] initWithHexColor:"FFFFFF" specularColor:"FFFFFF" attenuation:0.02];
	[[RendererManager getInstance] addLight:whiteLight];
	[whiteLight setPosition:[7, 7, 4]];

	// Set the scene ambient color
	[[RendererManager getInstance] setSceneAmbient:"333333"];

	// Initialise view and projection matrices
	var lookat = [GLU lookAt:5 eyey:10 eyez:15 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
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

	// Rotate the spheres
	for (var i = 0; i < _sceneObjects.length; i++) {
		[_sceneObjects[i] setRotation:_sphereAngle x:0 y:1 z:0];
	}

	// Move the lights
	var blueAngle = _lightAngle;
	var redAngle = -(blueAngle + 120 % 360);
	var greenAngle = redAngle + 12 % 360;
	var yellowAngle = _lightAngle;
	var cyanAngle = -(yellowAngle + 90 % 360);
	var magentaAngle = cyanAngle + 90 % 360;
	[_blueLight setPosition:[7 * Math.sin(blueAngle * Math.PI / 90), 7 * Math.cos(blueAngle * Math.PI / 90), 7 * Math.cos(blueAngle * Math.PI / 180)]];
	[_redLight setPosition:[7 * Math.sin(redAngle * Math.PI / 145), 7 * Math.cos(redAngle * Math.PI / 145), 7 * Math.cos(redAngle * Math.PI / 180)]];
	[_greenLight setPosition:[7 * Math.sin(greenAngle * Math.PI / 60), 7 * Math.cos(greenAngle * Math.PI / 60), 7 * Math.cos(greenAngle * Math.PI / 180)]];
	[_yellowLight setPosition:[7 * Math.sin(yellowAngle * Math.PI / 90), 7 * Math.cos(yellowAngle * Math.PI / 180), 7 * Math.cos(yellowAngle * Math.PI / 90)]];
	[_cyanLight setPosition:[7 * Math.sin(cyanAngle * Math.PI / 145), 7 * Math.cos(cyanAngle * Math.PI / 180), 7 * Math.cos(cyanAngle * Math.PI / 145)]];
	[_magentaLight setPosition:[7 * Math.sin(magentaAngle * Math.PI / 60), 7 * Math.cos(magentaAngle * Math.PI / 180), 7 * Math.cos(magentaAngle * Math.PI / 60)]];

	// Render the scene
	[[RendererManager getInstance] render];

	_sphereAngle = (_sphereAngle + 2) % 360;
	_lightAngle = _lightAngle + 2 % 360;
	
	// flush
	[_glContext flush];
}

@end
