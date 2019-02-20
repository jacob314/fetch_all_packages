package ffive.image.quantizeplugin;

import java.nio.ByteBuffer;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import ffive.image.quantizeplugin.quantizd.QuantizerParams;
import ffive.image.quantizeplugin.quantizd.QuantizerRunnable;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.getkeepsafe.relinker.ReLinker;


/**
 * QuantizePlugin
 */
public class QuantizePlugin implements MethodCallHandler {


    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "quantize_plugin");

        QuantizePlugin instance = new QuantizePlugin(registrar);
        channel.setMethodCallHandler(instance);

        try {
             ReLinker.recursively().loadLibrary(registrar.context(), "natives");
        } catch(Exception e){
            e.printStackTrace();
        }
    }


    private final Registrar mRegistrar;

    private QuantizePlugin(Registrar registrar) {
        this.mRegistrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {

        switch (call.method) {

            case "load_original":
                preload(call, result);
                break;

            case "quantize":
                quantize(call, result);
                break;

            default:
                break;
        }
    }

    private void preload(MethodCall call, Result result) {


        // https://habr.com/post/326146/ threadPool = new
       try {
           threadPool = new ThreadPoolExecutor(2, 2, 30, TimeUnit.SECONDS, workQueue, new ThreadPoolExecutor.DiscardOldestPolicy()); //);

           srcW = (int) call.argument("width");
           srcH = (int) call.argument("height");


           qOriginal = ByteBuffer.allocateDirect(srcH * srcW * 4);
           qOriginal.put((byte[]) call.argument("original"));
       } catch (Exception e){
           result.error("Quantize plugin load error","Couldn't preload image for quantize", false);
       }

        result.success(true);
    }


    private final BlockingQueue<Runnable> workQueue =
            new ArrayBlockingQueue<Runnable>(4);
    private ThreadPoolExecutor threadPool;
    private ByteBuffer qOriginal;
    private int srcW, srcH;

    private void quantize(MethodCall call, MethodChannel.Result result) {

        QuantizerParams qParams = new QuantizerParams();

        qParams.width = (int) call.argument("width");
        qParams.height = (int) call.argument("height");
        qParams.quality = (int) call.argument("quality");
        qParams.dither = (boolean) call.argument("dither");
        qParams.ditherLevel = (int) call.argument("ditherLvl");
        qParams.numColors = (int) call.argument("numColors");
        qParams.srcWidth = srcW;
        qParams.srcHeight = srcH;


        threadPool.submit(new QuantizerRunnable(qOriginal, qParams, result));
    }
}
