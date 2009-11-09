@import "../OJGL/GLRenderer.j"

@implementation TextureLightingRenderer : GLRenderer {
	int _texCoordAttributeLocation;
	int _samplerUniformLocation;

	int _normalAttributeLocation;
	int _normalMatrixUniformLocation;
	
	int _sceneAmbientUniformLocation;
	
	// light characteristics
	Array _lightPositionLocation;
	Array _lightAmbientLocation;
	Array _lightDiffuseLocation;
	Array _lightSpecularLocation;
	Array _lightAttenuationFactorLocation;
	Array _lightEnabledLocation;

	Array _lights;
}

- (id)initWithContext:(GLContext)context {
	self = [super initWithContext:context vertexShaderFile:@"Resources/shaders/pointLightingTexture.vsh" fragmentShaderFile:@"Resources/shaders/pointLightingTexture.fsh"];
	
	if (self) {
		_lights = [];
	}

	return self;
}

- (void)onShadersLoaded {
    [super onShadersLoaded];


	// Get attribute/uniform locations
	_normalAttributeLocation = [_glProgram getAttributeLocation:"a_normal"];

	_normalMatrixUniformLocation = [_glProgram getUniformLocation:"u_normalMatrix"];

	_sceneAmbientUniformLocation = [_glProgram getUniformLocation:"u_sceneAmbientColor"];

	_lightPositionLocation = [];
	_lightAmbientLocation = [];
	_lightDiffuseLocation = [];
	_lightSpecularLocation = [];
	_lightAttenuationFactorLocation = [];
	_lightEnabledLocation = [];
	
	for (var i = 0; i < 8; i++) {
		var lightStruct = "u_light[" + i + "].";
		var lightEnabled = "u_lightEnabled[" + i + "]";

		_lightPositionLocation.push([_glProgram getUniformLocation:lightStruct + "position"]);
		_lightAmbientLocation.push([_glProgram getUniformLocation:lightStruct + "ambientColor"]);
		_lightDiffuseLocation.push([_glProgram getUniformLocation:lightStruct + "diffuseColor"]);
		_lightSpecularLocation.push([_glProgram getUniformLocation:lightStruct + "specularColor"]);
		_lightAttenuationFactorLocation.push([_glProgram getUniformLocation:lightStruct + "attenuation"]);
		_lightEnabledLocation.push([_glProgram getUniformLocation:lightEnabled]);
	}
	
	
	_texCoordAttributeLocation = [_glProgram getAttributeLocation:"a_texCoord"];

	// Set up the texture sampler
	[_glContext setUniformSampler:[_glProgram getUniformLocation:"s_texture"]];

	// Callback
	[super callback]
}

- (void)setupMatrices {
	[super setupMatrices];
	
	[_glContext setUniformMatrix3:_normalMatrixUniformLocation matrix:_mvMatrix];

}

- (void)setNormalBufferData:(int)bufferId {
	// Bind the vertex buffer data to the vertex attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_normalAttributeLocation size:3];
}

- (void)setTexCoordBufferData:(int)bufferId {
	// Bind the texture coordinates buffer data to the texcoord attribute
	[_glContext bindBufferToAttribute:bufferId attributeLocation:_texCoordAttributeLocation size:2];
}

- (void)setTexture:(int)textureId {
	// Bind the texture
	[_glContext bindTexture:textureId];
}

- (int)addLight:(GLLight)light {
	if (_lights.length < 8) {
		_lights.push(light);
	} else {
		CPLog.error("Number of lights exceeds 8");
	}
}

- (void)renderLights {
	for (var i = 0; i < 8; i++) {
		if (i < _lights.length) {
			// enable light
			[_glContext setUniform1i:_lightEnabledLocation[i] value:1];
			
			// set light colors
			[_glContext setUniform4f:_lightAmbientLocation[i] values:[_lights[i] ambientLight]];
			[_glContext setUniform4f:_lightDiffuseLocation[i] values:[_lights[i] diffuseLight]];
			[_glContext setUniform4f:_lightSpecularLocation[i] values:[_lights[i] specularLight]];
			
			// set light position, take into account translation from viewer's position
			var transformedLightPosition = _viewMatrix.multVec([_lights[i] position]);
			[_glContext setUniform4f:_lightPositionLocation[i] values:transformedLightPosition];
			
			// set attenuation factor
			[_glContext setUniform1f:_lightAttenuationFactorLocation[i] value:[_lights[i] attenuation]];
		} else {
			[_glContext setUniform1i:_lightEnabledLocation[i] value:0];
		}
	}
	
	// Set scene ambient levels
	[_glContext setUniform4f:_sceneAmbientUniformLocation values:[0.15, 0.15, 0.15, 1.0]];
}



@end
