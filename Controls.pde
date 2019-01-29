boolean alwaysSend = true;

void keyPressed() {
  if (key == ' ') {
    sendGfx.beginDraw();
    sendGfx.background(0);
    sendGfx.endDraw();
  }
}

void mouseReleased() {
  if (!alwaysSend) oscSend();
}
