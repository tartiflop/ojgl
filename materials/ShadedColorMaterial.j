@import "../OJGL/GLMaterial.j"

@implementation ShadedColorMaterial : GLMaterial {

	Array _ambientColor;
	Array _diffuseColor;
	Array _specularColor;
	float _shininess;
	
}

- (id)initWithHexColors:(String)ambient diffuse:(String)diffuse specular:(String)specular shininess:(float)shininess {
	self = [super init];
	
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

- (void)prepareRenderer:(GLRenderer)renderer {
	[renderer setNormalBufferData:[_primitive getNormalBufferId]];

	[renderer setMaterialData:_ambientColor diffuseColor:_diffuseColor specularColor:_specularColor shininess:_shininess];
}


@end

