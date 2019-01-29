// https://github.com/torbjornlunde/processing-experiments
// https://www.processing.org/discourse/beta/num_1215762729.html
// https://forum.processing.org/one/topic/converting-bufferedimage-to-pimage.html

import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriter;
import javax.imageio.ImageWriteParam;
import javax.imageio.stream.MemoryCacheImageOutputStream;
import javax.imageio.IIOImage;
import java.io.ByteArrayOutputStream;
import java.io.ByteArrayInputStream;

byte[] encodeJpeg(PImage img, float compression) throws IOException {
  ByteArrayOutputStream baos = new ByteArrayOutputStream();
  
  ImageWriter writer = ImageIO.getImageWritersByFormatName("jpeg").next();
  ImageWriteParam param = writer.getDefaultWriteParam();
  param.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
  param.setCompressionQuality(compression);

  // ImageIO.write((BufferedImage) img.getNative(), "jpg", baos);
  writer.setOutput(new MemoryCacheImageOutputStream(baos));

  writer.write(null, new IIOImage((BufferedImage) img.getNative(), null, null), param);

  return baos.toByteArray();
}

byte[] encodeJpeg(PImage img) throws IOException {
  return encodeJpeg(img, 0.5F);
}

PImage decodeJpeg(byte[] imgbytes) throws IOException, NullPointerException {
  BufferedImage imgbuf = ImageIO.read(new ByteArrayInputStream(imgbytes));
  PImage img = new PImage(imgbuf.getWidth(), imgbuf.getHeight(), RGB);
  imgbuf.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
  img.updatePixels();

  return img; 
}
