PGraphics receiveGfx;
PGraphics sendGfx;
color fillColor;

void setup() {
  size(640, 480, P2D);
  oscSetup();
  
  receiveGfx = createGraphics(width, height, P2D);
  receiveGfx.beginDraw();
  receiveGfx.background(0);
  receiveGfx.endDraw();
  
  sendGfx = createGraphics(width, height, P2D);
  sendGfx.beginDraw();
  sendGfx.background(0);
  sendGfx.endDraw();
  
  fillColor = color(127 + random(127), 127 + random(127), 127 + random(127), 127);
}

void draw() {
  blendMode(NORMAL);
  background(0);
  blendMode(ADD);

  if (receiveBytes != null) {
    try {
      receiveGfx.beginDraw();
      receiveGfx.image(decodeJpeg(receiveBytes), 0, 0);
      receiveGfx.endDraw();
      receiveBytes = null;
    } catch (Exception e) { }
  }
  image(receiveGfx, 0, 0);
  
  // ~ ~ ~ ~ ~
  
  if (mousePressed) {
    sendGfx.beginDraw();
    sendGfx.fill(fillColor);
    sendGfx.noStroke();
    sendGfx.ellipse(mouseX, mouseY, 10, 10);
    sendGfx.stroke(fillColor);
    sendGfx.strokeWeight(2);
    sendGfx.line(mouseX, mouseY, pmouseX, pmouseY);
    sendGfx.endDraw();
    if (alwaysSend) oscSend();
  }
  
  image(sendGfx, 0, 0);
  
  surface.setTitle("" + frameRate);  
}
