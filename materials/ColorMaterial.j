@import "../OJGL/GLMaterial.j"

@implementation ColorMaterial : GLMaterial {

	Array _ambientColor;
	Array _diffuseColor;
	Array _specularColor;
	float _shininess;
	
}

- (id)initWithHexColors:(String)ambient diffuse:(String)diffuse specular:(String)specular shininess:(float)shininess precise:(BOOL)precise {
	if (precise) {
		self = [super initWithRendererType:GENERIC_PIXEL_RENDERER_TYPE];
	} else {
		self = [super initWithRendererType:GENERIC_RENDERER_TYPE];
	}
	
	if (self) {
		_ambientColor = hexToRGB(ambient);
		_diffuseColor = hexToRGB(diffuse);
		_specularColor = hexToRGB(specular);

		_shininess = shininess; 
	}
	
	return self;
}

- (void)prepareGL:(GLContext)glContext {

	// Tell primitive to use normal data and associate it with a buffer
	[_primitive prepareNormals:glContext];
}

- (void)prepareRenderer {
	
	var renderer = [[RendererManager getInstance] getRenderer:_rendererType];
	[renderer setNormalBufferData:[_primitive getNormalBufferId]];

	[renderer setMaterialData:_ambientColor diffuseColor:_diffuseColor specularColor:_specularColor shininess:_shininess];
}


@end

