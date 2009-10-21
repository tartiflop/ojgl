@import <Foundation/CPObject.j>
@import "GLContext.j"

@implementation GLTexture : CPObject {
	CPString _filename;
	Image _image;
	GLContext _glContext;
	
	int _textureId;
}

- (id)initWithFilename:(CPString)filename glContext:(GLContext)glContext {
	self = [super init];
	
	if (self) {
		_filename = filename;
		_glContext = glContext;
		
		[self load];
			
	}
	
	return self;
}

- (void)load {
	
	_image = new Image();
	
	_image.onload = function() {
		[self onLoad];
	}
	
	_image.onerror = function() {
		[self onError];
	}
	
	_image.onabort = function() {
		[self onAbort];
	}
	
	_image.src = _filename;
}

- (int)textureId {
	return _textureId;
}

- (void)onLoad {
	CPLog.info("Loaded texture data from " + _filename)
	
	_textureId = [_glContext createTextureFromImage:_image];
}

- (void)onError {
	CPLog.error("Error loading texture data from " + _filename)
	
}

- (void)onAbort {
	CPLog.error("Aborted Loading of texture data from " + _filename)
	
}

@end
