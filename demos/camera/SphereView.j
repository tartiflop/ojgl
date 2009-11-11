@import "../../OJGL/GLView.j"
@import "../../OJGL/GLU.j"
@import "../../primitives/Sphere.j"
@import "../../primitives/SphereBurst.j"
@import "../../materials/TextureMaterial.j"
@import "../../materials/RandomColorMaterial.j"
@import "../../renderers/RendererManager.j"

@implementation SphereView : GLView {
	GLContext _glContext;
	
	float _angle;
	BOOL _ready;
    Matrix4D _lookAt;
    float _keyX, _keyY, _keyZ;
    
    Array _sceneObjects;
    
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_ready = NO;
		_keyX = _keyY = _keyZ = 0;
		
		_sceneObjects = [];
		
		// Get the OpenGL Context
		_glContext = [self glContext];

		// Initialise the renderer manager
		[[RendererManager alloc] initWithContext:_glContext];
		
		// build the scene
		[self initScene];
	}
	
	return self;
}

- (BOOL)acceptsFirstResponder
{
    return YES;
}

- (void)initTextureRenderer {
	
	// Initialise the texture renderer, create scene when ready
	_textureRenderer = [[GenericRenderer alloc] initWithContext:_glContext];
	[_textureRenderer load:self onComplete:@selector(initScene)]
}

- (void)initScene {
		
	// Prepare (initialise) context
	[_glContext prepare:[0.0, 0.0, 0.0, 1] clearDepth:1.0];
	[_glContext enableBackfaceCulling];
	[_glContext enableTexture];
	
	for (var k = 0; k < 3; k++) {
		for (var j = 0; j < 3; j++) {
			for (var i = 0; i < 3; i++) {
                var primitive;
				
				if ((i + j + k) % 2 == 0) {

					var textureMaterial = [[TextureMaterial alloc] initWithTextureFile:"Resources/images/mars.jpg"];
					primitive = [[Sphere alloc] initWithGeometry:textureMaterial radius:1.2 longs:25 lats:25];
                    [primitive setTranslation:((i - 1) * 4) y:((j - 1) * 4) z:((k - 1) * 4)];

				} else {
					var colorMaterial = [[RandomColorMaterial alloc] init];
					primitive = [[SphereBurst alloc] initWithGeometry:colorMaterial radius:1.2 longs:25 lats:25];
                    [primitive setTranslation:((i - 1) * 4) y:((j - 1) * 4) z:((k - 1) * 4)];
		
				}

				[primitive prepareGL:_glContext];
				[[RendererManager getInstance] addPrimitive:primitive];
				_sceneObjects.push(primitive);
			}
		}		
	}		

	
	// reshape 
	[_glContext reshape:[self width] height:[self height]];

	// Initialise view and projection matrices
	_lookAt = [GLU lookAt:0 eyey:0 eyez:15 centerx:0 centery:0 centerz:0 upx:0 upy:1 upz:0];
	[[RendererManager getInstance] setViewMatrix:_lookAt];
	
	var perspective = [GLU perspective:60 aspect:[self width]/[self height] near:1 far:10000];
	[[RendererManager getInstance] setProjectionMatrix:perspective];

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
    
	// recalculate rotation matrix
	_angle = (_angle + 0.5) % 360;

	// Clear context
	[_glContext clearBuffer];

	// Update camera position
	_lookAt.tx += _keyX;
	_lookAt.ty += _keyY;
	_lookAt.tz += _keyZ;
	[[RendererManager getInstance] setViewMatrix:_lookAt];

	// Rotate all spheres
	for (var i = 0; i < _sceneObjects.length; i++) {
		[_sceneObjects[i] setRotation:_angle x:0 y:1 z:0];
	}
	
	// Render the scene
	[[RendererManager getInstance] render];

	// flush
	[_glContext flush];
}


@end
