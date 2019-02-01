void keyPressed() {
  if (key == ' ') { // clear
    sendGfx.beginDraw();
    sendGfx.background(0);
    sendGfx.endDraw();
  }
}
