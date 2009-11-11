#define MAX_LIGHTS 8

struct Light {
	vec4 position;
	vec4 ambientColor;
	vec4 diffuseColor;
	vec4 specularColor;
	float attenuation;
};

struct Material {
	vec4 ambientColor;
	vec4 diffuseColor;
	vec4 specularColor;
	float shininess;
};

uniform sampler2D s_texture;
uniform bool u_useTexture;

uniform Light u_light[MAX_LIGHTS];
uniform int u_lightEnabled[MAX_LIGHTS];

uniform Material u_material;
uniform bool u_lightingEnabled;

uniform bool u_includeSpecular;


varying vec4 v_ambient;

varying vec4 v_ecPosition3;
varying vec3 v_normal;
varying vec3 v_eye;
varying vec2 v_texCoord;

const float	c_zero = 0.0;
const float	c_one = 1.0;

vec4 color;
vec4 specular;

void pointLight(in int lightIndex,
				inout vec4 ambient,
				inout vec4 diffuse,
				inout vec4 specular) {

	float nDotVP;
	float eDotRV;
	float pf;
	float attenuation;
	float d;
	vec3 VP;
	vec3 reflectVector;


	// Vector between light position and vertex
	VP = vec3(u_light[lightIndex].position - v_ecPosition3);
	
	// Distance between the two
	d = length(VP);
	
	// Normalise
	VP = normalize(VP);
	
	// Calculate attenuation (only quadratic)
	attenuation = c_one / (c_one + u_light[lightIndex].attenuation * d * d);
	
	// angle between normal and light-vertex vector
	nDotVP = max(c_zero, dot(VP, v_normal));
	
	if (nDotVP > c_zero) {
		diffuse += u_light[lightIndex].diffuseColor * nDotVP * attenuation;
	
		if (u_includeSpecular) {
			// reflected vector					
			reflectVector = normalize(reflect(-VP, v_normal));
			
			// angle between eye and reflected vector
			eDotRV = max(c_zero, dot(v_eye, reflectVector));
			eDotRV = pow(eDotRV, 16.0);
		
			pf = pow(eDotRV, u_material.shininess);
			specular += u_light[lightIndex].specularColor * pf * attenuation;
		}
	}
}

void doLighting() {
	int i;
	vec4 amb = vec4(c_zero);
	vec4 diff = vec4(c_zero);
	vec4 spec = vec4(c_zero);

	if (u_lightingEnabled) {
		for (i = int(c_zero); i < MAX_LIGHTS; i++) {
			if (u_lightEnabled[i] == 1) {
				pointLight(i, amb, diff, spec);
			} 	
		}

		color = v_ambient + diff * u_material.diffuseColor;
		color.a = u_material.diffuseColor.a;
		specular = spec * u_material.specularColor;
		specular.a = u_material.specularColor.a;
	} else {
		color = u_material.diffuseColor;
		specular = spec;
	}
}

void main() {

	doLighting();	
	if (u_useTexture) {
		color = texture2D(s_texture, v_texCoord) * color;
	}
	gl_FragColor = color + specular;
}
 
	
