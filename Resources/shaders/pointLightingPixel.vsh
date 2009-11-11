#define MAX_LIGHTS 8

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
uniform bool u_lightingEnabled;

varying vec4 v_ambient;
varying vec2 v_texCoord;

varying vec4 v_ecPosition3;
varying vec3 v_normal;
varying vec3 v_eye;


void main(void) {
	v_ecPosition3 = u_mvMatrix * a_vertex;
	v_eye = -vec3(normalize(v_ecPosition3));

	v_normal = u_normalMatrix * a_normal;
	v_normal = normalize(v_normal);
	
	if (u_lightingEnabled) {
		v_ambient = u_sceneAmbientColor * u_material.ambientColor;
	}
	
	gl_Position = u_mvpMatrix * a_vertex;
	v_texCoord = a_texCoord;
}
