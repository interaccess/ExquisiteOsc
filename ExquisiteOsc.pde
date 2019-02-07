PGraphics receiveGfx;
PGraphics sendGfx;
color fillColor;
int scaleFactor = 2;

void setup() {
  size(960, 540, P2D);
  
  oscSetup();
  
  receiveGfx = createGraphics(width, height, P2D);
  receiveGfx.beginDraw();
  receiveGfx.background(0);
  receiveGfx.endDraw();
  
  sendGfx = createGraphics(width/scaleFactor, height/scaleFactor, P2D);
  sendGfx.beginDraw();
  sendGfx.background(0);
  sendGfx.endDraw();
  
  fillColor = randomColor();
}

void draw() {
  blendMode(NORMAL);
  background(0);
  blendMode(ADD);

  drawReceived();
  
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  
  if (mousePressed) {
    sendGfx.beginDraw();
    sendGfx.fill(fillColor, 127);
    sendGfx.noStroke();
    sendGfx.ellipse(mouseX/scaleFactor, mouseY/scaleFactor, 10, 10);
    sendGfx.stroke(fillColor);
    sendGfx.strokeWeight(2);
    sendGfx.line(mouseX/scaleFactor, mouseY/scaleFactor, pmouseX/scaleFactor, pmouseY/scaleFactor);
    sendGfx.endDraw();
  }
  
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

  image(sendGfx, 0, 0, width, height);
  
  oscSend();
  
  if (doRecord) screenShot(false);
    
  surface.setTitle("" + frameRate);  
}

void drawReceived() {
if (receiveBytes != null) {
    try {
      receiveGfx.beginDraw();
      receiveGfx.image(decodeJpeg(receiveBytes), 0, 0, width, height);
      receiveGfx.endDraw();
      receiveBytes = null;
    } catch (Exception e) { }
  }
  image(receiveGfx, 0, 0, width, height);
}

color randomColor() {
    return color(127 + random(127), 127 + random(127), 127 + random(127), 127);
}
