@import <Foundation/CPObject.j>
@import "GLContext.j"

var _allImages = nil;

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
		
		if (_allImages == nil) {
			_allImages = [[CPDictionary alloc] init];
		}
		
		[self load];
			
	}
	
	return self;
}

- (void)load {
	
	// Only load files once: reuse image data if used for different textures
	if ([[_allImages allKeys] containsObject:_filename]) {
		_image = [_allImages objectForKey:_filename];
		onLoad();
		
		return;
	}
	
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
	// Save image data
	if (![[_allImages allKeys] containsObject:_filename]) {
		CPLog.info("Loaded texture data from " + _filename)
		[_allImages setObject:_image forKey:_filename];
	}
	
	_textureId = [_glContext createTextureFromImage:_image];
}

- (void)onError {
	CPLog.error("Error loading texture data from " + _filename)
	
}

- (void)onAbort {
	CPLog.error("Aborted Loading of texture data from " + _filename)
	
}

@end
