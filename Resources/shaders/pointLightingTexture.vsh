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

varying vec4 v_color;
varying vec4 v_specular;
varying vec2 v_texCoord;

const float	c_zero = 0.0;
const float	c_one = 1.0;

vec4 ecPosition3;
vec3 normal;

vec4 materialAmbient;
vec4 materialDiffuse;
vec4 materialSpecular;
float materialShininess;


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


	vec3 eye = -vec3(normalize(ecPosition3));
	
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
	
		// reflected vector					
		reflectVector = normalize(reflect(-VP, normal));
		
		// angle between eye and reflected vector
		eDotRV = max(c_zero, dot(eye, reflectVector));
		eDotRV = pow(eDotRV, 16.0);
	
		pf = pow(eDotRV, materialShininess);
		specular += u_light[lightIndex].specularColor * pf * attenuation;
	}
	
	

}

void doLighting() {
	int i;
	vec4 amb = vec4(c_zero);
	vec4 diff = vec4(c_zero);
	vec4 spec = vec4(c_zero);

	for (i = int(c_zero); i < MAX_LIGHTS; i++) {
		if (u_lightEnabled[i] == 1) {
			pointLight(i, amb, diff, spec);
		} 	
	}
	
	v_color = (u_sceneAmbientColor + amb) * materialAmbient + diff * materialDiffuse;
	v_color.a = materialDiffuse.a;
	v_specular = spec * materialSpecular;
	v_specular.a = materialSpecular.a;
}


void main(void) {
	ecPosition3 = u_mvMatrix * a_vertex;
	normal = u_normalMatrix * a_normal;

	normal = normalize(normal);
	
//	materialAmbient = u_material.ambientColor;
//	materialDiffuse = u_material.diffuseColor;
//	materialSpecular = u_material.specularColor;
//	materialShininess = u_material.shininess;
	
	materialAmbient = vec4(c_one, c_one, c_one, c_one);
	materialDiffuse = vec4(c_one, c_one, c_one, c_one);
	materialSpecular = vec4(c_one, c_one, c_one, c_one);
	materialShininess = 0.7;
	
	
	doLighting();

	gl_Position = u_mvpMatrix * a_vertex;
	v_texCoord = a_texCoord;
}
