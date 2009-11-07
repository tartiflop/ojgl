varying vec2 v_texCoord;
uniform sampler2D s_texture;

void main(void) {
	gl_FragColor = texture2D(s_texture, v_texCoord);
}
	
	