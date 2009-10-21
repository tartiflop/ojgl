varying vec2 vTexCoord;
uniform sampler2D sTexture;

void main(void) {
	gl_FragColor = texture2D(sTexture, vTexCoord);
}
	
	