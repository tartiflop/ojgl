@import "GenericRenderer.j"

@implementation GenericPixelRenderer : GenericRenderer {
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/shaders/pointLightingPixel.vsh" fragmentShaderFile:@"Resources/shaders/pointLightingPixel.fsh"];
	
	if (self) {
		_lights = [];
		_sceneAmbient = [0.0, 0.0, 0.0, 1.0];
		_lightingEnabled = YES;
	}

	return self;
}

@end
