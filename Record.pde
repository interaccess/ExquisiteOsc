boolean doRecord = false;
int recordInterval = 2000;
int frameCounter = 0;
int markTime = 0;
String fileName = "frame";
String fileType = "jpg";

void screenShot(boolean trigger) {
  if (trigger || millis() > markTime + recordInterval) {
    markTime = millis();
    saveFrame("render/" + fileName + "_" + zeroPadding(frameCounter, 99999) + "." + fileType);
    frameCounter++;
  }
}

String zeroPadding(int val, int maxVal) {
  String q = "" + maxVal;
  return nf(val, q.length());
}
