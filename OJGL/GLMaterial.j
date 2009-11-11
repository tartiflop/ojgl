@import <Foundation/CPObject.j>
@import "GLContext.j"
@import "GLRenderer.j"
@import "GLPrimitive.j"
@import "../renderers/RendererManager.j"

@implementation GLMaterial : CPObject {
	GLPrimitive _primitive;
	
	String _rendererType;
	
}

- (id)initWithRendererType:(String)rendererType {
	self = [super init];
	
	if (self) {
		_rendererType = rendererType;
		[[RendererManager getInstance] registerRenderer:rendererType];
	}
	
	return self;
}


- (void)setPrimitive:(GLPrimitive)primitive {
	_primitive = primitive;
}

- (GLPrimitive)getPrimitive {
	return _primitive;
}

- (void)prepareGL:(GLContext)glContext {

}

- (void)prepareRenderer {

}

- (String)getRendererType {
	return _rendererType;
}


@end
