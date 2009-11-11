@import "../OJGL/GLMaterial.j"
@import "../OJGL/GLTexture.j"

@implementation TextureMaterial : GLMaterial {

	GLTexture _texture;
	CPString _textureFilename;
	float _shininess;
	BOOL _shiny;
	
}

- (id)initWithTextureFile:(CPString)textureFilename shininess:(float)shininess precise:(BOOL)precise {
	if (precise) {
		self = [super initWithRendererType:GENERIC_PIXEL_RENDERER_TYPE];
	} else {
		self = [super initWithRendererType:GENERIC_RENDERER_TYPE];
	}
	
	if (self) {
		_textureFilename = textureFilename;
		_shininess = shininess;
		
		if (_shininess == 0) {
			_shiny = NO;
		} else {
			_shiny = YES;
		}
	}
	
	return self;
}

- (void)prepareGL:(GLContext)glContext {
	// Create the texture map from an image
	_texture = [[GLTexture alloc] initWithFilename:_textureFilename glContext:glContext];

	// Tell primitive to use UV data and associate it with a buffer
	[_primitive prepareUVs:glContext];

	// Tell primitive to use normal data and associate it with a buffer
	[_primitive prepareNormals:glContext];
}

- (void)prepareRenderer {
	
	var renderer = [[RendererManager getInstance] getRenderer:_rendererType];
	
	[renderer setTexCoordBufferData:[_primitive getUVBufferId]];

	// Bind the texture
	if (_shiny) {
		[renderer setTextureWithShininess:[_texture textureId] shininess:_shininess];
	} else {
		[renderer setTexture:[_texture textureId]];
	}

	[renderer setNormalBufferData:[_primitive getNormalBufferId]];
}


@end
