PGraphics receiveGfx;
PGraphics sendGfx;
color fillColor;
Settings settings;
int sW = 960;
int sH = 540;

void setup() {
  size(50, 50, P2D);
  settings = new Settings("settings.txt");
  surface.setSize(sW, sH);
  
  oscSetup();
  
  receiveGfx = createGraphics(width, height, P2D);
  receiveGfx.beginDraw();
  receiveGfx.background(0);
  receiveGfx.endDraw();
  
  sendGfx = createGraphics(width, height, P2D);
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
    sendGfx.ellipse(mouseX, mouseY, 10, 10);
    sendGfx.stroke(fillColor);
    sendGfx.strokeWeight(2);
    sendGfx.line(mouseX, mouseY, pmouseX, pmouseY);
    sendGfx.endDraw();
    oscSend();
  }
  
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

  image(sendGfx, 0, 0, width, height);
  
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
