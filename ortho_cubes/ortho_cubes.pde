final int num_x = 6;
final int num_y = 6;
Box[][] boxes = new Box[num_x][num_y];
void setup() {
  smooth(8);
  frameRate(50);
  size(1000, 900, P3D);
  float xoff = sqrt(2)*100;
  float xoff2 = sqrt(2)*50;
  float yoff = 121; // magic number
  float centerx = xoff2/2+((1000 - (num_x*xoff))/2);
  //float centery = 0;
  float centery = 10+((900 - (num_y*yoff))/2);
  for (int y = 0; y < num_y; y = y+1) {
    for (int x = 0; x < num_x; x = x+1) {
      if (y%2 == 0) {
        boxes[x][y] = new Box(xoff*x+centerx, xoff*y+centery, color(y*50,120,100));
      }
      else {
        boxes[x][y] = new Box(xoff*x+xoff2+centerx, xoff*y+centery, color(y*50,120,100));
      }
    } 
  } 
}

void draw() {
  lights();
  background(20);
  float far = map(mouseX, 0, width, 120, 400);
  ortho();
  for (int y = 0; y < num_y; y = y+1) {
    for (int x = 0; x < num_x; x = x+1) {
      boxes[x][y].update();
      boxes[x][y].display();
    } 
  } 
  saveFrame("frames/######.png");
}

void keyPressed() {
  if (key == 'd' ) {
    for (int y = 0; y < num_y; y = y+1) {
      for (int x = 0; x < num_x; x = x+1) {
        boxes[x][y].next();
      } 
    } 
  }
}

class Box { 
  float xpos, ypos;
  float rot;
  color col;
  int target_state = 0; // 0 45 90 135 180 225 270 315 
  float steps,speed,acceleration,topspeed;
  int c = 0;
  Box (float x, float y, color c) {  
    ypos = y; 
    xpos = x; 
    col = c;
    rot = 0;
    speed = 0.2;
    acceleration = 0.02;
    topspeed = 1.9;
  } 
  void next() {
    this.target_state += 1;
    this.c++;
    if (this.c >8){
        exit(); 
    }
    if(this.target_state > 7) {
      
      this.target_state = 0; 
    }
  }
  void update() {
    //println(round(degrees(this.rot)) +" " +(this.target_state * 45));
    if(round(degrees(this.rot)) != (this.target_state * 45)){
      this.speed += this.acceleration;
      if(this.speed >= this.topspeed){
        this.speed = this.topspeed;
        this.acceleration = -this.acceleration;
      }
      if(this.speed <= 0.2){
        this.speed = 0.2;
      }
      this.rot += radians(this.speed);
      if(this.rot >= TWO_PI){
        this.rot = 0; 
      }
    }else{
      speed = 0.2;
      acceleration = 0.1;
      this.next();
    }
  }
  void display() { 
    push();
    translate(this.xpos, this.ypos, 0);
    rotateX(this.rot);
    rotateY(this.rot);
    strokeWeight(1);
    stroke(200);
    fill(this.col);
    box(100);
    pop();
  } 
} 
