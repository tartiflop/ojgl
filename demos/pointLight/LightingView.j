@import "../../OJGL/GLView.j"
@import "../../OJGL/GLU.j"
@import "../../OJGL/GLLight.j"
@import "../../primitives/SphereBurst.j"
@import "../../materials/ShadedColorMaterial.j"
@import "../../renderers/SimpleLightRenderer.j"

@implementation LightingView : GLView {
	GLContext _glContext;
	SimpleLightRenderer _lightRenderer;
	GLLight _light1;
	GLLight _light2;
	GLLight _light3;
	float _angle;
	
	SphereBurst _sphere;
	BOOL _ready;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_ready = NO;
		
		// Get the OpenGL Context
		_glContext = [self glContext];

		// Initialise the light renderer
		_lightRenderer = [[SimpleLightRenderer alloc] initWithContext:_glContext];
		[_lightRenderer load:self onComplete:@selector(initScene)];
		
		_angle = 0;
	}
	
	return self;
}

- (void)initScene {
		
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];

	// Create sphere with Color material
	var colorMaterial = [[ShadedColorMaterial alloc] initWithHexColors:"111111" diffuse:"BBBBBB" specular:"BBBBBB" shininess:0.7];
	var _sphere = [[SphereBurst alloc] initWithGeometry:colorMaterial radius:4 longs:100 lats:100];
	[_sphere prepareGL:_glContext];
	
	_light1 = [[GLLight alloc] initWithHexColor:"0000FF" specularColor:"FFFFFF"];
	[_light1 setAttenuation:0.02];
	[_lightRenderer addLight:_light1];
	
	_light2 = [[GLLight alloc] initWithHexColor:"FF0000" specularColor:"FFFFFF"];
	[_light2 setAttenuation:0.05];
	[_lightRenderer addLight:_light2];
	
	_light3 = [[GLLight alloc] initWithHexColor:"00FF00" specularColor:"FFFFFF"];
	[_light3 setAttenuation:0.05];
	[_lightRenderer addLight:_light3];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise projection matrix
	var lookat = [GLU lookAt:0 eyey:0 eyez:15 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];

	var projectionMatrix = new Matrix4D(perspective);
	projectionMatrix.multiply(lookat);
	
	// Send projection matrices to the renderers (shaders)
	[_lightRenderer setActive];
	[_lightRenderer setViewMatrix:lookat];
	[_lightRenderer setProjectionMatrix:perspective];
	//[_lightRenderer setProjectionMatrix:projectionMatrix];

	_ready = YES;
}

- (void)drawRect:(CPRect)dirtyRect {
	
	// Only render the scene if ready
	if (!_ready) {
		return;
	}
	
	// Clear context
	[_glContext clearBuffer];

	// Render the sphere
	[_lightRenderer setActive];

	[_sphere translateTo:0 y:0 z:0];
	
	[_light1 setPosition:[2 * Math.cos(_angle * Math.PI / 90), 10 * Math.sin(_angle * Math.PI / 90), 5]];
	[_light2 setPosition:[10 * Math.sin(_angle * Math.PI / 90), 2 * Math.cos(_angle * Math.PI / 30), 5]];
	[_light3 setPosition:[5 * Math.cos(_angle * Math.PI / 60), 5 * Math.cos(_angle * Math.PI / 120), 5]];
	[_lightRenderer renderLights];
	
	[_sphere render:_lightRenderer];

	_angle = _angle + 1 % 360;

	
	// flush
	[_glContext flush];
}


@end
