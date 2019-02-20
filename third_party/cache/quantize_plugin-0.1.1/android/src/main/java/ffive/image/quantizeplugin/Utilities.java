package ffive.image.quantizeplugin;

import java.nio.ByteBuffer;

public class Utilities {


    public static native byte[] quantize(ByteBuffer src, ByteBuffer dst,int srcW, int srcH, int dstW, int dstH, int numColors, int quality, boolean dither, int dither_lvl);
}
