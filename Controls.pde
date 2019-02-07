void keyPressed() {
  switch(key) {
    case('n'): // new
      sendGfx.beginDraw();
      sendGfx.background(0);
      sendGfx.endDraw();
      fillColor = randomColor();
      break;
    case('c'): // color
      fillColor = randomColor();
      break;
  }
}
