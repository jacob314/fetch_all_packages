package ffive.image.quantizeplugin.quantizd;

import java.nio.ByteBuffer;

public class QuantizerParams {

    public  byte[] pixels;
    public int width;
    public int height ;
    public  int numColors;


    public int quality;
    public boolean dither;
    public int ditherLevel;
    public int srcWidth;
    public int srcHeight;
}
