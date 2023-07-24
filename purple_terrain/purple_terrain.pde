import ddf.minim.analysis.*;
import ddf.minim.*;
import com.hamoid.*;

Minim minim;
AudioInput in;
AudioPlayer set;
FFT fft;

int cols, rows;
int scl = 30;
int w = 1920;
int h = 2400;
float[][] terrain;
float[][] dotz;


void setup() {
  cols = w/scl;
  rows = h/scl;
  terrain = new float[cols][rows];
  dotz = new float[cols][rows];
  minim = new Minim(this);

  set = minim.loadFile("music.wav", 2048);
  fft = new FFT(set.bufferSize(), set.sampleRate());
  
  for (int y = 0; y < rows; y++) {
    for (int x = 0; x < cols; x++) {
      terrain[x][y] = 0;
      dotz[x][y] = 0;
    }
  }
  frameRate(60);
  size(1920, 1080, P3D );
}


void draw_triangle_strip(){
  strokeWeight(2);
  for (int y = 0; y < 2; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 1; x < cols; x++) {
      stroke(255);
      vertex(x*scl, y*scl, dotz[x][y]);
      vertex(x*scl, (y+1)*scl, dotz[x][y+1]);
    }
    endShape();
  }
}
void draw_lines(){
  for (int y = 0; y < rows-1; y++) {
    strokeWeight(1);
    stroke(120, 0, 255);
    
    //additional lines
    beginShape(LINES);
    for (int x = 1; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();
    //end
    
    strokeWeight(2);
    if(y>1){
      beginShape(LINES);
    for (int x = 1; x < cols; x++) {
      if (y<2) {
        stroke(255);
      }
      vertex(x*scl, y*scl, dotz[x][y]);
      vertex(x*scl, (y+1)*scl, dotz[x][y+1]);
    }
    endShape();
    }
    
  }
}
//floating camera settings
float a = 0.0;
float b = 0.0;
float ainc = 0.025;
float binc = 0.0125;

void update_camera(){
  camera(width/2.0 + sin(b) * 100, //eyeX, 
        height/0.5 + 300, //eyeY, 
        (height/2.0) / tan(PI*30.0 / 180.0) + sin(a)*30 -300, //eyeZ, 
        width/2.0+ sin(b)*100, //centerX, 
        height/2.0, //centerY, 
        300 + sin(a)*30-200, //centerZ, 
        0, //upX, 
        1, //upY, 
        0);//upZ
  a = a + ainc;
  b = b + binc;
}
void update_fft(){
  fft.forward(set.mix);
  for (int y = rows-2; y >= 0; y--) {
    for (int x = 0; x < cols; x++) {
      float bandDB = 20 * log( 2 * fft.getBand(x) / fft.timeSize() );
      terrain[x][0] = map( bandDB, 0, -150, 100, -100 );
      dotz[x][0] = map( fft.getBand(x), 0, -150, 200, 0 ) -180;
    }
    for (int x = 0; x < cols; x++) {
      terrain[x][y+1] = terrain[x][y];
      dotz[x][y+1] = dotz[x][y];
    }
  }
}
void draw() {
  update_fft();
  background(0);
  noFill();
  update_camera();
  draw_triangle_strip();
  draw_lines();
}

void keyPressed(){
 if (key == 'p'){
  set.play(); 
 }
}
