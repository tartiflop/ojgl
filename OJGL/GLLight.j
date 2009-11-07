@import <Foundation/CPObject.j>

@implementation GLLight : CPObject {
	Array _position;
	
	Array _ambientLight;
	Array _diffuseLight;
	Array _specularLight;

	float _attenuation;
}

- (id)initWithHexColor:(String)color specularColor:(String)specularColor {
	self = [super init];
	
	if (self) {
		_position = [0, 0, 0];
		_attenuation = 0;
		
		_ambientLight = hexToRGB(color);
		_diffuseLight = [_ambientLight[0], _ambientLight[1], _ambientLight[2], 1.0];
		_specularLight = hexToRGB(specularColor);
	}
	
	return self;
}

- (void)setPosition:(Array)position {
	_position = position;
}

- (void)setAttenuation:(float)attenuation {
	_attenuation = attenuation;
}

- (Array)position {
	return [_position[0], _position[1], _position[2], 1];
}

- (Array)ambientLight {
	return _ambientLight;
}

- (Array)diffuseLight {
	return _diffuseLight;
}

- (Array)specularLight {
	return _specularLight;
}

- (float)attenuation {
	return _attenuation;
}


@end
