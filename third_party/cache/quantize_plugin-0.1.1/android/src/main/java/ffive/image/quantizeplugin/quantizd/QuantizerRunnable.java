package ffive.image.quantizeplugin.quantizd;


import ffive.image.quantizeplugin.Utilities;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.nio.ByteBuffer;
import java.util.ArrayList;

public class QuantizerRunnable implements Runnable {


    public QuantizerRunnable(ByteBuffer src,
                             QuantizerParams params,
                             MethodChannel.Result result) {
        this.qOriginal = src;
        this.quantizerParam = params;
        this.result = result;

    }

    ByteBuffer qOriginal;
    QuantizerParams quantizerParam;
    MethodChannel.Result result;

    @Override
    public void run() {

        ByteBuffer dst = ByteBuffer.allocateDirect(quantizerParam.width * quantizerParam.height);


        byte[] palette = Utilities.quantize(
                qOriginal,
                dst,
                quantizerParam.srcWidth,
                quantizerParam.srcHeight,
                quantizerParam.width,
                quantizerParam.height,
                quantizerParam.numColors,
                quantizerParam.quality,
                quantizerParam.dither,
                quantizerParam.ditherLevel);


        byte[] indices = new byte[dst.remaining()];
        dst.position(0);
       // if(isCancelled()) return null;
        dst.get(indices, 0, dst.remaining());
       // if(isCancelled()) return null;
        ArrayList<Object> datagramm = new ArrayList<>(2);
       // if(isCancelled()) return null;
        datagramm.add(0, indices);
      //  if(isCancelled()) return null;
        datagramm.add(1, palette);

      //  if(isCancelled()) return null;
        result.success( datagramm);

    }
}
