
@import <AppKit/CPView.j>
@import "GLContext.j"

@implementation GLView : CPView {

	DOMElement _DOMCanvasElement;
	GLContext _gl;
}

- (id)initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	
	if (self) {
		_DOMCanvasElement = document.createElement("canvas");
		_DOMCanvasElement.width = CGRectGetWidth([self bounds]);
		_DOMCanvasElement.height = CGRectGetHeight([self bounds]);
		_DOMCanvasElement.style.top = "0px";
		_DOMCanvasElement.style.left = "0px";
		
		_DOMElement.appendChild(_DOMCanvasElement);

		_gl = [[GLContext alloc] initWithGL:[self _context]];
		[self prepareOpenGL];
	}
	
	return self;
}

- (void)setNeedsDisplay:(BOOL)aFlag
{
  [self drawRect:nil]; // Because the right way to do it is too slow.
}

- (void)prepareOpenGL {
}

- (GLContext)glContext {
	return _gl;
}

- (int)width {
	return _DOMCanvasElement.width;
}

- (int)height {
	return _DOMCanvasElement.height;
}

- (DOMElement)_context {
	
	var gl;
	try { 
		gl = _DOMCanvasElement.getContext("webkit-3d");
		return gl;
	} catch(e) {
	}

	try { 
		gl = _DOMCanvasElement.getContext("moz-webgl"); 
	} catch(e) {
	}

	if (!gl) {
		CPLog.error(@"Could not create context")
		return nil;
	}
	
	return gl;
}

@end
