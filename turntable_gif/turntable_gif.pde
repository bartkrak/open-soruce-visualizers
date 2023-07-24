final int num_tt = 8;
Turntable[] tttoptop = new Turntable[num_tt];
Turntable[] tttop = new Turntable[num_tt];
Turntable[] ttmid = new Turntable[num_tt];
Turntable[] ttbottom = new Turntable[num_tt];

float sin_sim = 0;
float sin_base = 0;
float sin_speed = PI/200.0;
int frame_counter = 0;
void setup() {
  frameRate(50);
  size(1280,720, P3D);
  int tt_width = width+700;
  int tt_w_offset = 575;
  for (int i=0; i < num_tt; i++) {         
    tttoptop[i] = new Turntable(i*(tt_width/num_tt+100)-tt_w_offset,0,-180,i*PI/4);
    tttop[i] = new Turntable(i*(tt_width/num_tt+100)-tt_w_offset,0,-350,i*PI/4);
    ttmid[i] = new Turntable(i*(tt_width/num_tt+100)-tt_w_offset,0,-600,i*PI/4);
    ttbottom[i] = new Turntable(i*(tt_width/num_tt+100)-tt_w_offset,0,-950,i*PI/4);
  }
}

void draw() {
  translate(0, -50);
  rotateX(PI/3);
  background(30);
  for (int i=0; i < num_tt; i++) {         
    tttoptop[i].display();
    tttop[i].display();
    ttmid[i].display();
    ttbottom[i].display();
  }
  frame_counter++;
  if(frame_counter < 401){
    println(frame_counter);
    // uncomment this line if you want to save frames
    //saveFrame("frame-"+frame_counter+".png");
  }
}

class Turntable { 
  float ypos, xpos, zpos, fspeed,animate, sinarm,sinbase,sinvinyl,animatearm,animatebase,animatevinyl,multiplier; 
  color silver, label, vinyl, base;
  Turntable (float x, float y, float z, float off) {  
    fspeed = PI/200.0;
    ypos = y; 
    xpos = x; 
    zpos = z; 
    sinarm = off + PI/4;
    sinbase = off + 0;
    sinvinyl = off + PI/8;
    animatearm = 0;
    animatebase = 0;
    animatevinyl = 0;
    multiplier = 10;
    silver = color(100,100,100);
    label = color(100,0,100);
    vinyl = 20;
    base = color( 34, 89, 53);
  } 
  void update() { 
    animatearm = sin(sinarm) * (multiplier+3);
    sinarm += fspeed;
    animatevinyl = sin(sinvinyl) * multiplier;
    sinvinyl += fspeed;
    animatebase = sin(sinbase) * multiplier;
    sinbase += fspeed;
  } 
  void display() {
    update();
    
    strokeCap(ROUND);
    push();
    translate(xpos, ypos, zpos);
    strokeWeight(2);
    // base
    push();
    translate(0,0,animatebase);
    fill(base);
    box(300,240,50);
    // tempo slider
    push();
    translate(110,0,26);
    fill(base);
    rect(0,0,25,100);
    push();
    translate(0,0,1);
    fill(20);
    rect(10,3,5,94);
    translate(0,0,1);
    fill(silver);
    rect(4,55,17,10);
    pop();
    pop();
    // start stop button
    push();
    fill(silver);
    translate(-145,90,26);
    rect(0,0,35,25);
    pop();
    pop();
    
    // arm 
    push();
    fill(silver);
    translate(60, 0, 50+animatearm);
    rotateZ(PI/6);
    box(10,150,10);
    translate(0,-80,-5);
    box(30,30,15);
    pop();
    
    // vinyl
    push();
    translate(0, 0, 35+animatevinyl);
    fill(vinyl);
    circle(-30,0,200);
    translate(0, 0, 1);
    fill(label);
    circle(-30,0,70);
    pop();
    pop();
  }
} 
