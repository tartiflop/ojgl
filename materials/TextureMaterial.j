@import "../OJGL/GLMaterial.j"
@import "../OJGL/GLTexture.j"

@implementation TextureMaterial : GLMaterial {

	GLTexture _texture;
	CPString _textureFilename;
}

- (id)initWithTextureFile:(CPString)textureFilename {
	self = [super init];
	
	if (self) {
		_textureFilename = textureFilename;

	}
	
	return self;
}

- (void)prepareGL:(GLContext)glContext {
	// Create the texture map from an image
	_texture = [[GLTexture alloc] initWithFilename:_textureFilename glContext:glContext];

	// Tell primitive to use UV data and associate it with a buffer
	[_primitive prepareUVs:glContext];
}

- (void)prepareRenderer:(GLRenderer)renderer {
	[renderer setTexCoordBufferData:[_primitive getUVBufferId]];

	// Bind the texture
	[renderer setTexture:[_texture textureId]];

}


@end
