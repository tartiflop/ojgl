@import <Foundation/CPObject.j>
@import <Foundation/CPDictionary.j>
@import "../OJGL/GLContext.j"
@import "SimpleColorRenderer.j"
@import "GenericRenderer.j"
@import "GenericPixelRenderer.j"


SIMPLE_COLOR_RENDERER_TYPE = "SimpleColorRenderer";
GENERIC_RENDERER_TYPE = "GenericRenderer";
GENERIC_PIXEL_RENDERER_TYPE = "GenericPixelRenderer";

var _instance = nil;

@implementation RendererManager : CPObject {

	GLContext _context;
	
	CPDictionary _activeRenderers;
	int _numberOfRegisteredRenderers;
	int _numberOfReadyRenderers;
}

- (id)initWithContext:(GLContext)context {
	self = [super init];
	
	if (self) {
		_context = context;
		
		_activeRenderers = [[CPDictionary alloc] init];
		_numberOfRegisteredRenderers = 0;
		_numberOfReadyRenderers = 0;
		
		_instance = self;
	}
	
	return self;
}


+ (RendererManager)getInstance {
	return _instance;
}

- (void)registerRenderer:(String)rendererType {
	if (![[_activeRenderers allKeys] containsObject:rendererType]) {
		_numberOfRegisteredRenderers++;
		var renderer = nil;
		if (rendererType == SIMPLE_COLOR_RENDERER_TYPE) {
			renderer = [[SimpleColorRenderer alloc] initWithContext:_context];
		
		} else if (rendererType == GENERIC_RENDERER_TYPE) {
			renderer = [[GenericRenderer alloc] initWithContext:_context];
		
		} else if (rendererType == GENERIC_PIXEL_RENDERER_TYPE) {
			renderer = [[GenericPixelRenderer alloc] initWithContext:_context];
		} 
		
		if (renderer != nil) {
			[_activeRenderers setObject:renderer forKey:rendererType];
			[renderer load:self onComplete:@selector(rendererLoaded)];
			
		} else {
			CPLog.error("Unknown renderer type for registerRenderer: " + rendererType);
		}
	}
	
}

- (void)rendererLoaded {
	_numberOfReadyRenderers++;
}

- (BOOL)isReady {
	return _numberOfReadyRenderers == _numberOfRegisteredRenderers;
}

- (GLRenderer)getRenderer:(String)rendererType {
	
	var renderer = [_activeRenderers objectForKey:rendererType];
	if (renderer == nil) {
		CPLog.error("Unknown renderer type for getRenderer: " + rendererType);
	}

	return renderer;
}

- (void)setProjectionMatrix:(Matrix4D)projectionMatrix {
	var allRenderers = [_activeRenderers allValues];
	for (var i = 0; i < allRenderers.length; i++) {
		[allRenderers[i] setActive];
		[allRenderers[i] setProjectionMatrix:projectionMatrix];
	}	
}

- (void)setViewMatrix:(Matrix4D)viewMatrix {
	var allRenderers = [_activeRenderers allValues];
	for (var i = 0; i < allRenderers.length; i++) {
		[allRenderers[i] setActive];
		[allRenderers[i] setViewMatrix:viewMatrix];
	}	
}

- (void)addPrimitive:(GLPrimitive)primitive {
	var rendererType = [[primitive getMaterial] getRendererType];
	[[self getRenderer:rendererType] addPrimitive:primitive];
}

- (void)addLight:(GLLight)light {
	var allRenderers = [_activeRenderers allValues];
	for (var i = 0; i < allRenderers.length; i++) {
		[allRenderers[i] addLight:light];
	}	
}

- (void)setSceneAmbient:(String)ambient {
	var allRenderers = [_activeRenderers allValues];
	for (var i = 0; i < allRenderers.length; i++) {
		[allRenderers[i] setSceneAmbient:ambient];
	}	
}

- (void)render {
	if ([self isReady]) {
		var allRenderers = [_activeRenderers allValues];
		for (var i = 0; i < allRenderers.length; i++) {
			[allRenderers[i] render];
		}
	}
}


@end
