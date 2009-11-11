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


attribute vec4 a_vertex;
attribute vec3 a_normal;
attribute vec2 a_texCoord;

uniform mat4 u_mvpMatrix;
uniform mat4 u_mvMatrix;
uniform mat3 u_normalMatrix;

uniform vec4 u_sceneAmbientColor;

uniform Material u_material;
uniform Light u_light[MAX_LIGHTS];
uniform int u_lightEnabled[MAX_LIGHTS];

uniform bool u_includeSpecular;
uniform bool u_lightingEnabled;

varying vec4 v_color;
varying vec4 v_specular;
varying vec2 v_texCoord;

const float	c_zero = 0.0;
const float	c_one = 1.0;

vec4 ecPosition3;
vec3 normal;
vec3 eye;

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
	VP = vec3(u_light[lightIndex].position - ecPosition3);
	
	// Distance between the two
	d = length(VP);
	
	// Normalise
	VP = normalize(VP);
	
	// Calculate attenuation (only quadratic)
	attenuation = c_one / (c_one + u_light[lightIndex].attenuation * d * d);
	
	// angle between normal and light-vertex vector
	nDotVP = max(c_zero, dot(VP, normal));
	
// 	ambient += u_light[lightIndex].ambientColor * attenuation;
	if (nDotVP > c_zero) {
		diffuse += u_light[lightIndex].diffuseColor * nDotVP * attenuation;
	
		if (u_includeSpecular) {
			// reflected vector					
			reflectVector = normalize(reflect(-VP, normal));
			
			// angle between eye and reflected vector
			eDotRV = max(c_zero, dot(eye, reflectVector));
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

		v_color = (u_sceneAmbientColor + amb) * u_material.ambientColor + diff * u_material.diffuseColor;
		v_color.a = u_material.diffuseColor.a;
		v_specular = spec * u_material.specularColor;
		v_specular.a = u_material.specularColor.a;
	} else {
		v_color = u_material.diffuseColor;
		v_specular = spec;
	}
}


void main(void) {
	ecPosition3 = u_mvMatrix * a_vertex;
	eye = -vec3(normalize(ecPosition3));

	normal = u_normalMatrix * a_normal;
	normal = normalize(normal);
	
	doLighting();

	gl_Position = u_mvpMatrix * a_vertex;
	v_texCoord = a_texCoord;
}
