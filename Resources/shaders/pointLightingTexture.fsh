varying vec4 v_color;
varying vec4 v_specular;
varying vec2 v_texCoord;

uniform sampler2D s_texture;


void main() {
	vec4 color = texture2D(s_texture, v_texCoord) * v_color;
	gl_FragColor = color + v_specular;
}
 
	
