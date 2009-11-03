@import <Foundation/CPObject.j>
@import "GLContext.j"
@import "GLRenderer.j"
@import "GLPrimitive.j"

@implementation GLMaterial : CPObject {
	GLPrimitive _primitive @accessors(property=primitive);
}

- (id)init {
	self = [super init];
	
	if (self) {
	}
	
	return self;
}

- (void)prepareGL:(GLContext)glContext {

}

- (void)prepareRenderer:(GLRenderer)renderer {

}


@end
