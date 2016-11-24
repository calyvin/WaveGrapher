float time = 0;
float radius = 100;
float speed = 1;
float currentRadians;
int mode = 1;

boolean tracing = false;
ArrayList<PVector> points = new ArrayList<PVector>();
Slider radiusSlider, speedSlider;
void setup() {
  size(1000, 400);
  ellipseMode(RADIUS);
  rectMode(CENTER);
  radiusSlider = new Slider(35, 50, 100, .5);
  speedSlider = new Slider(150, 50, 100, map(1, 0.514285714, 4, 0, 1 ));
}

void draw() {
  background(255);

  fill(255, 0, 0, 50);
  rect(0, 0, 1000, 100);
  fill(0, 255, 0, 50);
  rect(0, 100, 300, 300);
  fill(0, 0, 255, 50);
  rect(300, 100, 700, 300);
  fill(255, 255, 0);
  rect(800, 25, 50, 50);
  fill(0);
  text("GRAPH", 804, 53);

  line(300, 250, 1000, 250);
  for (int i = 0; i <= 700; i++) {
    if (i % 90 == 0 ) {
      float x = 300 + i;
      line(x, 250-10, x, 250+10);
      fill(0);
      text(((int)round(10 *radians(i)*speed/PI))/10.0+ "π", x +2, 250+10);
    }
  }
  fill(0);

  text("Radius: " + (int)radius, 35, 35);
  text("Speed: " + speed, 150, 35);
  radiusSlider.update();
  speedSlider.update();
  if (!tracing) {
    speed = map(speedSlider.getPercent(), 0, 1, 0.514285714, 4);
    radius = radiusSlider.getPercent() * 100 + 40;
  }

  if (mode == 1) {
    text("Radians: " + round(10*currentRadians/PI)/10.0 + "π", 35, 130);
    fill(255);
    ellipse(150, 250, radius, radius);
  } else if (mode == 2) {
    text("Radians: " + round(10*currentRadians/PI)/10.0 + "π", 35, 130);
    fill(255);
    rectMode(CENTER);
    rect(150, 250, radius*2, radius*2);
    rectMode(CORNER);
  }

  if (tracing) {
    float x = 0, y = 0;

    if (currentRadians / speed < 4*PI) time += speed;
    else tracing = false;
    
    currentRadians = radians(time*speed);
    
    if (mode == 1) {
      x = radius*cos(currentRadians);
      y = radius*sin(currentRadians);
    }else if (mode == 2) {

      if(currentRadians % (2*PI) <= PI/4){
        x = radius;
        y = tan(currentRadians)*radius;
      } else if(currentRadians % (2*PI) <= 3*PI/4){
        x = radius/tan(currentRadians);
        y = radius;
      } else if(currentRadians % (2*PI) <= 5*PI/4){
        x =-radius;
        y = -tan(currentRadians)*radius;
      } else if(currentRadians % (2*PI) <= 7*PI/4){
        x = -radius/tan(currentRadians);
        y = -radius;
      } else {
        x = radius;
        y = tan(currentRadians)*radius;
      }
    }

    float s = time;
    line(150, 250, 150+x, 250-y);
    line(150+x, 250-y, 300+time, 250 - y);
    points.add(new PVector(s, y));
    
  }
  for (int i = 1; i < points.size(); i++) {
    line(300+points.get(i-1).x, 250-points.get(i-1).y, 300+points.get(i).x, 250-points.get(i).y);
  }
}

void mousePressed() {
  if (!tracing && mouseX > 800 && mouseY > 25 && mouseX <850 && mouseY < 75) {
    time = 0;
    points.clear();
    points.add(new PVector(0, 0));
    tracing = true;
    currentRadians=0;
  }
}

void keyPressed() {
}

void  mouseReleased() {
  radiusSlider.selected = false;
  speedSlider.selected = false;
}

class Slider {
  float x, y, l;
  float handlePercent;
  boolean selected = false;
  Slider(float x, float y, float l, float handlePercent) {
    this.x = x;
    this.y = y;
    this.l = l;
    this.handlePercent = constrain(handlePercent, 0, 1);
  }

  void update() {
    line(x, y, x+l, y);
    rectMode(CENTER);

    float handlePosition = x + (l*handlePercent);
    if (!selected && (mousePressed && (mouseX < handlePosition + 10 && mouseX > handlePosition - 10 && mouseY > y - 10 && mouseY <y + 10))) selected = true;


    if (selected) {
      handlePercent = map(constrain(mouseX, x, x+l), x, x + l, 0, 1);
    } 

    rect(handlePosition, y, 20, 20);
    handlePercent=constrain(handlePercent, 0, 1);
    rectMode(CORNER);
  }
  float getPercent() {
    return handlePercent;
  }
}