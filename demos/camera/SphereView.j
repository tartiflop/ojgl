@import "../../OJGL/GLView.j"
@import "../../OJGL/GLU.j"
@import "../../primitives/Sphere.j"
@import "../../primitives/SphereBurst.j"
@import "../../materials/TextureMaterial.j"
@import "../../materials/RandomColorMaterial.j"
@import "../../renderers/SimpleTexRenderer.j"
@import "../../renderers/SimpleColorRenderer.j"

@implementation SphereView : GLView {
	GLContext _glContext;
	SimpleTexRenderer _textureRenderer;
	SimpleColorRenderer _colorRenderer;
	
	Sphere _textureSphere;
	SphereBurst _colorSphere;
	float _angle;
	BOOL _ready;
    Matrix4D _lookAt;
    float _keyX, _keyY, _keyZ;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_ready = NO;
		_keyX = _keyY = _keyZ = 0;
		// Get the OpenGL Context
		_glContext = [self glContext];

		// Initialise the color renderer, load texture renderer when ready
		_colorRenderer = [[SimpleColorRenderer alloc] initWithContext:_glContext];
		[_colorRenderer load:self onComplete:@selector(initTextureRenderer)];
	}
	
	return self;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
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
	var textureMaterial = [[TextureMaterial alloc] initWithTextureFile:"Resources/images/mars.jpg"];
	var _textureSphere = [[Sphere alloc] initWithGeometry:textureMaterial radius:1.2 longs:25 lats:25];
	[_textureSphere prepareGL:_glContext];
	
	// Create sphere with Color material
	var colorMaterial = [[RandomColorMaterial alloc] init];
	var _colorSphere = [[SphereBurst alloc] initWithGeometry:colorMaterial radius:1.2 longs:25 lats:25];
	[_colorSphere prepareGL:_glContext];
	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise projection matrix
//	var ortho = [GLU ortho:-16 right:16 bottom:-12 top:12 near:1 far:10000];
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:0.1 far:1000];
    _lookAt = new Matrix4D(); _lookAt.tz = 0;
    [_textureRenderer setActive];
	[_textureRenderer setProjectionMatrix:perspective];
	[_textureRenderer setViewMatrix:_lookAt];
	
	// Send projection matrices to the renderers (shaders)
	[_colorRenderer setActive];
	[_colorRenderer setProjectionMatrix:perspective];
	[_colorRenderer setViewMatrix:_lookAt];

	_ready = YES;
}

- (void)keyDown:(CPEvent *)theEvent
{
    switch ([theEvent characters]) {
        case "w": _keyZ =  0.1; break;
        case "s": _keyZ = -0.1; break;
        case "d": _keyX = -0.1; break;
        case "a": _keyX =  0.1; break;
    }
    console.log([theEvent keyCode]);
    console.log([theEvent characters]);
}

- (void)keyUp:(CPEvent *)theEvent
{
    switch ([theEvent characters]) {
        case "w": _keyZ = 0; break;
        case "s": _keyZ = 0; break;
        case "d": _keyX = 0; break;
        case "a": _keyX = 0; break;
    }
}

- (void)mouseDragged:(CPEvent)anEvent {
    [[CPDOMWindowBridge sharedDOMWindowBridge] _propagateCurrentDOMEvent:YES];
}

- (void)mouseDown:(CPEvent)anEvent {
    [[CPDOMWindowBridge sharedDOMWindowBridge] _propagateCurrentDOMEvent:YES];
}

- (void)mouseUp:(CPEvent)anEvent {
    [[CPDOMWindowBridge sharedDOMWindowBridge] _propagateCurrentDOMEvent:YES];
}

- (void)drawRect:(CPRect)dirtyRect {
	
	// Only render the scene if ready
	if (!_ready) {
		return;
	}
    _lookAt.tx += _keyX;
    _lookAt.ty += _keyY;
    _lookAt.tz += _keyZ;
	// recalculate rotation matrix
	_angle = (_angle + 0.5) % 360;

	// Clear context
	[_glContext clearBuffer];

	// Multiple renderings of texture sphere
	[_textureRenderer setActive];
	[_textureSphere resetTransformation];
	[_textureRenderer setViewMatrix:_lookAt];
	[_textureSphere rotate:_angle x:0 y:1 z:0];
	for (var k = 0; k < 3; k++) {
		for (var j = 0; j < 3; j++) {
			for (var i = 0; i < 3; i++) {
                if ((i + j + k) % 2 == 0) {
					// Translate sphere, activate the texture renderer and render the texture sphere
                    [_textureSphere translateTo:((i - 1) * 4) y:((j - 1) * 4) z:((k - 1) * 4)];
					[_textureSphere render:_textureRenderer];
				}
			}
		}		
	}		
	
	// Multiple renderings of color sphere
	[_colorRenderer setActive];
	[_colorSphere resetTransformation];
	[_colorRenderer setViewMatrix:_lookAt];
	[_colorSphere rotate:_angle x:0 y:1 z:0];
	for (var k = 0; k < 3; k++) {
		for (var j = 0; j < 3; j++) {
			for (var i = 0; i < 3; i++) {
				if ((i + j + k) % 2 == 1) {
					// Translate sphere, activate the color renderer and render the color sphere
                    [_colorSphere translateTo:((i - 1) * 4) y:((j - 1) * 4) z:((k - 1) * 4)];
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
