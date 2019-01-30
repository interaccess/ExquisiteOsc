PGraphics receiveGfx;
PGraphics sendGfx;
color fillColor;
boolean doRecord = false;
int recordInterval = 2000;
int frameCounter = 0;
int markTime = 0;

void setup() {
  size(960, 540, P2D);
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
      receiveGfx.image(decodeJpeg(receiveBytes), 0, 0, width, height);
      receiveGfx.endDraw();
      receiveBytes = null;
    } catch (Exception e) { }
  }
  image(receiveGfx, 0, 0, width, height);
  
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  
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
  
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 
  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

  image(sendGfx, 0, 0, width, height);
  
  if (doRecord) {
    if (millis() > markTime + recordInterval) {
      markTime = millis();
      saveFrame("render/frame_" + zeroPadding(frameCounter, 99999) + ".jpg");
      frameCounter++;
    }
  }
  surface.setTitle("" + frameRate);  
}

String zeroPadding(int _val, int _maxVal){
  String q = ""+_maxVal;
  return nf(_val,q.length());
}
