package com.ss.android.flutter.ttimage;

import android.os.Handler;
import android.os.Looper;

import com.facebook.common.executors.CallerThreadExecutor;
import com.facebook.common.internal.Supplier;
import com.facebook.common.references.CloseableReference;
import com.facebook.datasource.BaseDataSubscriber;
import com.facebook.datasource.DataSource;
import com.facebook.datasource.DataSubscriber;
import com.facebook.datasource.FirstAvailableDataSourceSupplier;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.imagepipeline.memory.PooledByteBuffer;
import com.facebook.imagepipeline.request.ImageRequest;
import com.ss.android.image.FrescoUtils;
import com.ss.android.image.Image;

import java.util.LinkedList;
import java.util.List;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** TTImagePlugin */
public class TTImagePlugin implements MethodCallHandler {

    private Handler mHandler = new Handler(Looper.getMainLooper());

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "tt_image");
        channel.setMethodCallHandler(new TTImagePlugin());
    }

    @Override
    public void onMethodCall(final MethodCall call, final Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("fetchImage")) {
            final String url = call.argument("url");
            List<String> urlList = call.argument("url_list");
            Image image = new Image();
            image.url = url;
            if (urlList != null) {
                List<Image.UrlItem> urlItems = new LinkedList<>();
                for (String urlStr : urlList) {
                    Image.UrlItem item = new Image.UrlItem();
                    item.url = urlStr;
                    urlItems.add(item);
                }
                image.url_list = urlItems;
            }
            fetchEncodedImage(image, new BaseDataSubscriber<CloseableReference<PooledByteBuffer>>() {
                @Override
                protected void onNewResultImpl(DataSource<CloseableReference<PooledByteBuffer>> dataSource) {
                    if (!dataSource.isFinished()) {
                        return;
                    }

                    PooledByteBuffer pooledByteBuffer;
                    CloseableReference<PooledByteBuffer> closeableReference = dataSource.getResult();
                    if (closeableReference != null && closeableReference.get() != null) {
                        pooledByteBuffer = closeableReference.get();
                        try {
                            final byte[] bytes = new byte[pooledByteBuffer.size()];
                            pooledByteBuffer.read(0, bytes, 0, pooledByteBuffer.size());
                            mHandler.post(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(bytes);
                                }
                            });
                            return;
                        } finally {
                            CloseableReference.closeSafely(closeableReference);
                        }
                    }
                    mHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            result.error("fetchImageError", null, null);
                        }
                    });
                }

                @Override
                protected void onFailureImpl(DataSource<CloseableReference<PooledByteBuffer>> dataSource) {
                    mHandler.post(new Runnable() {
                        @Override
                        public void run() {
                            result.error("fetchImageFailed", null, null);
                        }
                    });
                }
            });
        } else {
            result.notImplemented();
        }
    }

    private static void fetchEncodedImage(Image image, DataSubscriber<CloseableReference<PooledByteBuffer>> subscriber) {
        final ImageRequest[] imageRequests = FrescoUtils.createImageRequests(image);
        List<Supplier<DataSource<CloseableReference<PooledByteBuffer>>>> suppliers = new LinkedList<>();
        for (int i = 0; i < imageRequests.length; i++) {
            final int finalI = i;
            suppliers.add(new Supplier<DataSource<CloseableReference<PooledByteBuffer>>>() {
                @Override
                public DataSource<CloseableReference<PooledByteBuffer>> get() {
                    return Fresco.getImagePipeline().fetchEncodedImage(imageRequests[finalI], null);
                }
            });
        }
        FirstAvailableDataSourceSupplier.create(suppliers).get().subscribe(subscriber, CallerThreadExecutor.getInstance());
    }

}
